require 'prawn'

class Report::GeneratePdf < Trailblazer::Operation
  include Prawn::View

  step Model(Report, :find_by)
  step Policy::Pundit( ::Session::Policy, :report_company_owner? )
  failure ::Session::Lib::ThrowException
  step :find_company!
  step :obj_array!
  step :saving_folder!
  step :generate_pdf!
  step :write_company_details!
  # step :write_company_logo!
  step :write_images!
  step :delete_images!
  step :save_pdf!

  # TODO : add check on Company and show error message in case is not set
  def find_company!(options, current_user:, **)
    options["company"] = Company.find_by("user_id like ?", current_user.id)
  end

  def obj_array!(options, current_user:, model:, **)
    options["obj_array"] = current_user.content["report_template"][model.content]
  end

  def saving_folder!(options, model:, **)
    options["saving_folder"] = Rails.root.join("public/reports/#{model.title}.pdf")
  end

  def generate_pdf!(options, *)
    options["pdf"] = Prawn::Document.new
  end

  def write_company_details!(options, pdf:, company:, **)
    font("Courier") do
      pdf.text company.name, :size => 12, :style => :bold, :align => :center
      pdf.text company.address_1, :align => :center
      pdf.text company.address_2, :align => :center
      pdf.text company.city + " " + company.postcode + " " + company.country, :align => :center
      pdf.text company.email, :align => :center
      pdf.text company.phone, :align => :center
      pdf.text company.website, :align => :center
    end

    pdf.stroke do
      line_at = pdf.cursor
      (line_at > 720 - MyDefault::ReportPdf["logo_size"]) ? (line_at = 720 - MyDefault::ReportPdf["logo_size"] - 5) : (line_at = pdf.cursor)
      pdf.horizontal_line 0, 550, :at => line_at
    end
  end

  def write_company_logo!(options, model:, pdf:, company:, **)
    pdf.image "#{Rails.root.join("/public/images/") + company.logo_meta_data[:thumb][:uid]}", :position => :left, :vposition => :top, :fit => [MyDefault::ReportPdf["logo_size"], MyDefault::ReportPdf["logo_size"]]
  end

  def write_images!(options, pdf:, obj_array:, **)
    obj_array.each do |obj|
      image_path = "#{Rails.root.join("public/temp_files/image-#{obj[:index]}.png")}"
      pdf.image image_path, :position => :center, :fit => [MyDefault::ReportPdf["chart_size"], MyDefault::ReportPdf["chart_size"]]
    end
  end

  def delete_images(options, obj_array:, **)
    obj_array.each do |obj|
      image_path = "#{Rails.root.join("public/temp_files/image-#{obj[:index]}.png")}"
      File.delete(image_path)
    end
  end

  def save_pdf!(options, pdf:, saving_folder:, **)
    pdf.render_file saving_folder.to_s
    return true
  end


end # class Report::GeneratePdf
