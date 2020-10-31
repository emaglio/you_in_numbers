require 'prawn'
require_dependency 'report/lib/report_utility'

class Report::GeneratePdf < Trailblazer::Operation
  include Prawn::View
  include ReportUtility

  step Model(Report, :find_by)
  step Policy::Pundit(::Session::Policy, :report_owner?)
  failure ::Session::Lib::ThrowException
  step :obj_array!
  step :check_files!
  step :find_company!
  step :saving_folder!
  step :elaborate_tables_data!
  step Rescue(NoMethodError, ArgumentError, Prawn::Errors::UnsupportedImageType,  handler: :rollback!){
    step :generate_pdf!
    step :write_company_details!
    step :write_company_logo!
    step :write_subject!
    step :write_objects!
    step :save_pdf!
    step :delete_images!
  }
  failure :error!

  def obj_array!(options, current_user:, model:, **)
    options["obj_array"] = current_user.content["report_template"][model.content["template"]]
  end

  def check_files!(_options, *)
    #TODO: return false if number of files is different than obj_array.size or folder not found
    return true
  end


  def find_company!(options, current_user:, **)
    options["company"] = ::Company.find_by(user_id: current_user.id)
  end

  def saving_folder!(options, model:, **)
    #TODO: make this editable by the USER
    #TODO: make name of the report editable by the USER %f %l bla bla
    options["saving_folder"] = Rails.root.join("public/reports/#{model.title}.pdf")
  end

  def elaborate_tables_data!(options, params:, **)
    return true if !params["table_obj"]

    options["tables"] = decode_table_data!(options, tables_data: params["table_obj"])
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
      line_at = if line_at > 720 - MyDefault::ReportPdf["logo_size"]
                  720 - MyDefault::ReportPdf["logo_size"] - 5
                else
                  pdf.cursor
                end
      pdf.horizontal_line 0, 550, :at => line_at
      options["current_cursor"] = line_at - 2
    end
  end

  def write_company_logo!(_options, pdf:, company:, **)
    return true if company.logo_meta_data == nil

    pdf.image "#{Rails.root.join("public/images/")}" + "#{company.logo[:thumb].uid}",
              :fit       => [MyDefault::ReportPdf["logo_size"], MyDefault::ReportPdf["logo_size"]],
              :position  => :right,
              :vposition => :top
  end

  def write_subject!(options, model:, current_user:, pdf:, current_cursor:, **)
    height_unm = current_user.content["report_settings"]["units_of_measurement"]["height"]
    weight_unm = current_user.content["report_settings"]["units_of_measurement"]["weight"]
    subject = ::Subject.find(model.subject_id)
    options["subject"] = subject
    data = [
      ["Firstname", "Lastname", "Date of Birth", "Height(#{height_unm})", "Weight(#{weight_unm})"],
      [
        "#{subject.firstname}", "#{subject.lastname}", "#{subject.dob.strftime("%d %B %Y")}",
        "#{subject.height}", "#{subject.weight}"
      ]
    ]
    pdf.move_cursor_to current_cursor
    pdf.table data, position: :center, width: 500 do
      cells.borders = []
      cells.align = :center
      row(0).font_style = :bold
      row(0).size = 14
    end

    pdf.stroke do
      pdf.horizontal_line 0, 550, :at => pdf.cursor
    end

    options["current_cursor"] = pdf.cursor
  end

  def write_objects!(options, pdf:, obj_array:, params:, current_cursor:, **)
    pdf.move_cursor_to current_cursor - 5
    options["paths"] = []
    obj_array.each do |obj|
      if obj[:type] == 'report/cell/chart'
        write_image!(options, obj: obj, pdf: pdf)
      else
        write_table!(options, params: params, pdf: pdf, obj: obj)
      end
    end
    footer(options, pdf: pdf, model: options["model"], subject: options["subject"], last_page: true)
  end

  def save_pdf!(_options, pdf:, saving_folder:, **)
    pdf.render_file saving_folder.to_s
    return true
  end

  def delete_images!(_options, paths:, **)
    paths.each do |path|
      File.delete(path)
    end
  end

  def rollback!(exception, options, *)
   options["error"] = exception.inspect
  end

  def error!(options, *)
    #TODO: delete folder create in Report::GenerateImage
  end


end # class Report::GeneratePdf
