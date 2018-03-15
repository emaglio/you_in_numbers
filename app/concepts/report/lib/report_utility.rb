class Report::GeneratePdf < Trailblazer::Operation

  module ReportUtility
    def write_image!(options, obj:, pdf:, **)
      footer(options, pdf: pdf, model: options[:model], subject: options["subject"]) if pdf.cursor < 320
      pdf.text obj[:title], :size => 12, :style => :bold, :align => :center
      image_path = "#{Rails.root.join("public/temp_files/image-#{obj[:index]}.png")}"
      options["paths"] << image_path
      pdf.image image_path, :position => :center, :fit => [MyDefault::ReportPdf["chart_size"], MyDefault::ReportPdf["chart_size"]]
      pdf.y = pdf.cursor + 3
    end

    def write_table!(options, params:, obj:, pdf:, **)
      obj[:type] == "report/cell/summary_table" ? write_summary_table(options, obj: obj, pdf: pdf) : write_training_zones(options, obj: obj, pdf: pdf)
      pdf.y = pdf.cursor + 3
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

      #the height of a row is about 25.5 so check if it fits otherwise go to the next page
      footer(options, pdf: pdf, model: options[:model], subject: options["subject"]) if pdf.cursor < (data.size*25.5)

      pdf.text obj[:title], :size => 12, :style => :bold, :align => :center
      pdf.table data, header: :true, position: :center, width: 400, row_colors: ["F4F4F4", "FFFFFF"]  do
        cells.align = :center
        cells.borders = [:bottom]
        rows(1..(data.size-2)).border_color = "F2F2F2"
        row(0).font_style = :bold
        row(0).size = 12
        column(0).font_style = :bold_italic
      end
    end

    def write_training_zones(options, obj:, pdf:, **)
      footer(options, pdf: pdf, model: options[:model], subject: options["subject"]) if pdf.cursor < 210

      pdf.text obj[:title], :size => 12, :style => :bold, :align => :center
      table = "training_zones_#{obj[:index]}"
      data = options["tables"][table]
      pdf.table data, position: :center, width: 400 do
        cells.borders = [:top]
        rows(0..3).background_color = "00E600"
        rows(1..3).border_color = "00E600"
        rows(4..7).background_color = "CC3300"
        rows(5..7).border_color = "CC3300"
        rows(7).borders = [:bottom]
        rows(7).border_color = "000000"
        cells.align = :center
        row(0).font_style = :bold
        row(4).font_style = :bold
        row(0).size = 12
        row(4).size = 12
      end
    end

    def footer(options, pdf:, model:, subject:, last_page: false, **)
      canvas do
        pdf.stroke_horizontal_line 0, 550, at: (bounds.bottom + 20)
        y_position = bounds.bottom + 10
        footer_name = "#{model.created_at.strftime("%d/%B/%Y")} - #{subject.firstname} #{subject.lastname}"
        pdf.text_box  footer_name,
                      :width => 100,
                      :height => 100,
                      :size => 8,
                      :align => :center,
                      at: [225, y_position]

        page_num = "Page #{pdf.page_count}"
        pdf.text_box  page_num,
                      :width => 50,
                      :height => 50,
                      :size => 8,
                      :align => :right,
                      at: [500 , y_position]
      end
      last_page ? true : pdf.start_new_page
    end
  end # class ReportUtility

end # module Report::GeneratePdf

