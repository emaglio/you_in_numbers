require 'prawn'

class Report::GeneratePdf < Trailblazer::Operation
  include Prawn::View

  step Model(Report, :find_by)
  step Policy::Pundit( ::Session::Policy, :report_owner? )
  failure ::Session::Lib::ThrowException
  step :obj_array!
  step :check_files!
  step :find_company!, fast_fail: true
  step :saving_folder!
  step :elaborate_tables_data!
  step Rescue( NoMethodError, ArgumentError, Prawn::Errors::UnsupportedImageType,  handler: :rollback! ){
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

  def check_files!(options, *)
    #TODO: return false if number of files is different than obj_array.size or folder not found
    return true
  end


  def find_company!(options, current_user:, **)
    options["company"] = ::Company.find_by("user_id like ?", current_user.id)
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
      (line_at > 720 - MyDefault::ReportPdf["logo_size"]) ? (line_at = 720 - MyDefault::ReportPdf["logo_size"] - 5) : (line_at = pdf.cursor)
      pdf.horizontal_line 0, 550, :at => line_at
    end
    options["current_cursor"] = pdf.cursor + 30
  end

  def write_company_logo!(options, model:, pdf:, company:, **)
    return true if (company.logo_meta_data == nil or company.logo_meta_data == {})
    options["path"] = ("#{Rails.root.join("public/images/")}" + "#{company.logo_meta_data[:thumb][:uid]}")
    pdf.image ("#{Rails.root.join("public/images/")}" + "#{company.logo_meta_data[:thumb][:uid]}"), :position => :right, :vposition => :top, :fit => [MyDefault::ReportPdf["logo_size"], MyDefault::ReportPdf["logo_size"]]
  end

  def write_subject!(options, model:, current_user:, pdf:, current_cursor:, **)
    height_unm = current_user.content["report_settings"]["units_of_measurement"]["height"]
    weight_unm = current_user.content["report_settings"]["units_of_measurement"]["weight"]
    subject = ::Subject.find(model.subject_id)
    data = [["Firstname", "Lastname", "Date of Birth", "Height(#{height_unm})", "Weight(#{weight_unm})"],
            ["#{subject.firstname}", "#{subject.lastname}", "#{subject.dob.strftime("%d %B %Y")}", "#{subject.height}", "#{subject.weight}"] ]
    pdf.y = current_cursor
    pdf.table data, position: :center, width: 500 do
      cells.borders = []
      cells.align = :center
      row(0).font_style = :bold
      row(0).size = 14
    end

    pdf.stroke do
      pdf.horizontal_line 0, 550, :at => pdf.cursor
    end

    pdf.y = pdf.cursor + 5
  end

  def write_objects!(options, pdf:, obj_array:, params:, current_cursor:, **)
    options["paths"] = []
    obj_array.each do |obj|
      obj[:type] == 'report/cell/chart' ? write_image!(options, obj: obj, pdf: pdf) : write_table!(options, params: params, obj: obj, pdf: pdf, current_cursor: current_cursor)
    end
  end

  def delete_images!(options, paths:, **)
    paths.each do |path|
      File.delete(path)
    end
  end

  def save_pdf!(options, pdf:, saving_folder:, **)
    pdf.render_file saving_folder.to_s
    return true
  end

  def rollback!(exception, options, *)
   options["error"] = exception.inspect + options["path"]
  end

  def error!(options, *)
    #TODO: delete folder create in Report::GenerateImage
  end

private
  def write_image!(options, obj:, pdf:, **)
    pdf.text obj[:title], :size => 12, :style => :bold, :align => :center
    image_path = "#{Rails.root.join("public/temp_files/image-#{obj[:index]}.png")}"
    options["paths"] << image_path
    pdf.image image_path, :position => :center, :fit => [MyDefault::ReportPdf["chart_size"], MyDefault::ReportPdf["chart_size"]]
  end

  def write_table!(options, params:, obj:, pdf:, **)
    pdf.text obj[:title], :size => 12, :style => :bold, :align => :center
    obj[:type] == "report/cell/summary_table" ? write_summary_table(options, obj: obj, pdf: pdf) : write_training_zones(options, obj: obj, pdf: pdf)
    pdf.y = pdf.cursor + 5
  end

  def decode_table_data!(options, tables_data:, **)
    num_tables = tables_data[/#{"//"}(.*?)#{"//"}/m, 1].to_i
    tables_data.slice!("//#{num_tables}//")
    tables = {}
    (1..num_tables).each_with_index do |index|
      type = tables_data[/#{"//"}(.*?)#{"//"}/m, 1]
      tables_data.slice!("//#{type}//")
      data = tables_data.split("//").first
      tables["#{type}"] = data
      tables_data.slice!(data)
    end

    tables.each do |key, value|
      value = value.tr('[]','')
      if key.include? "table"
        temp = value.split(",").map{ |i| JSON.parse(i).to_s}.each_slice(6).to_a
        #remove first element of array which is the ID used to order the table in js
        final_array = []
        temp.each do |array|
          array.shift
          final_array << array
        end
        tables["#{key}"] = temp
      else
        temp = value.split(",").map{ |i| JSON.parse(i).to_s}.each_slice(3).to_a
        #remove first element of array which is the ID used to order the table in js
        final_array = []
        temp.each do |array|
          array.shift
          final_array << array
        end
        tables["#{key}"] = temp
      end
    end

    return tables
  end

  def write_summary_table(options, obj:, pdf:, **)
    data = []
    header = ["", "@_AT", "@_MAX", "Pred", "Pred(%)"]
    table = "table_#{obj[:index]}"
    data << header
    options["tables"][table].each do |array|
      data << array
    end
    pdf.table data, position: :center, width: 400, row_colors: ["F0F0F0", "FFFFCC"]  do
      cell.first.borders = [:bottom]
      cell.last.borders = [:bottom]
      cells.align = :center
      row(0).font_style = :bold
      row(0).size = 14
    end
  end

  def write_training_zones(options, obj:, pdf:, **)
    table = "training_zones_#{obj[:index]}"
    data = options["tables"][table]
    pdf.table data, position: :center, width: 400 do
      cells.borders = []
      cells.align = :center
      row(0).font_style = :bold
      row(0).size = 14
    end
  end


end # class Report::GeneratePdf
