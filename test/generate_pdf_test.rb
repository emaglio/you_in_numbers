require 'test_helper.rb'
require 'prawn'

class Header
  include Prawn::View

  def initialize(model)
    @model = model
    @logo_size = 80
    @chart_size = 500
  end

  def write_details
    font("Courier") do
      text @model.name, :size => 12, :style => :bold, :align => :center
      text @model.address_1, :align => :center
      text @model.address_2, :align => :center
      text @model.city + " " + @model.postcode + " " + @model.country, :align => :center
      text @model.email, :align => :center
      text @model.phone, :align => :center
      text @model.website, :align => :center
    end
    stroke_axis
    stroke do
      line_at = cursor
      (line_at > 720 - @logo_size) ? (line_at = 720 - @logo_size - 5) : (line_at = cursor)
      horizontal_line 10, 550, :at => line_at
    end
  end

  def write_logo
    image "#{Rails.root.join("public/images/") + @model.logo[:thumb].url}", :position => :left, :vposition => :top, :fit => [@logo_size,@logo_size]
  end

  def write_table
    data = [["Firstname", "Lastname", "Date of Birth", "Height", "Weight"],
            ["erin", "whelan", "some", "other", "opthjer"] ]
    table data
  end

end

class GeneratehvPDF < MiniTest::Spec

  # it "description" do
  #   user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})["model"]

  #   company = Company::Create.({ user_id: user.id, name: "My Company", address_1: "address 1", address_2: "address 2", city: "Freshwater", postcode: "2096", country: "Australia",
  #                                 country: "Australia", email: "company@email.com", phone: "12345", website: "wwww.company.com.au", logo: File.open("test/images/logo.jpeg")
  #                               }, "current_user" => user)["model"]

  #   # upload_file = ActionDispatch::Http::UploadedFile.new({
  #   #   :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
  #   # })
  #   # report = Report::Create.({user_id: user.id, title: "Report", cpet_file_path: upload_file, template: "default"}, "current_user" => user)
  #   # report.success?.must_equal true

  #   path = "./test/greetings.pdf"

  #   # puts company.inspect

  #   greeter = Header.new(company)
  #   greeter.write_details
  #   greeter.write_table
  #   greeter.save_as(path)

  # end

  it "decoding data table" do
    # tables_data = "//3////table//[0,\"t (ss)\",\"06:35\",\"12:25\",\"-\",\"-\"],[1,\"VO2 (l/min)\",790,1662,\"\\u003c 2106\",\"Fair\"],[2,\"VO2/Kg (ml/min/Kg)\",15.2,32,\"\\u003c 35.1\",\"Fair\"],[3,\"RQ\",0.73,1.13,\"-\",\"-\"],[4,\"HR (bpm)\",108,168,\"183\",\"92\"],[5,\"Power (Watt)\",54,142,\"-\",\"-\"],[6,\"Revolution (BPM)\",58,54,\"-\",\"-\"],//training_zones//[0,\"Fat Burning (35-50% of VO2Max)\",\"Endurance (51-75% of VO2Max)\"],[1,\"HR (Bpm) 103 - 119\",\"HR (Bpm) 121 - 154\"],[2,\"Power (Watt) 46 - 63\",\"Power (Watt) 65 - 112\"],[3,\"Revolution (RPM) 57 - 58\",\"Revolution (RPM) 57 - 59\"],[4,\"Endurance (51-75% of VO2Max)\",\"Endurance (51-75% of VO2Max)\"],[5,\"HR (Bpm) 157 - 161\",\"HR (Bpm) 163 - 168\"],[6,\"Power (Watt) 114 - 125\",\"Power (Watt) 129 - 141\"],[7,\"Revolution (RPM) 59 - 62\",\"Revolution (RPM) 58 - 60\"],//training_zones//[0,\"Fat Burning (35-50% of VO2Max)\",\"Endurance (51-75% of VO2Max)\"],[1,\"HR (Bpm) 103 - 119\",\"HR (Bpm) 121 - 154\"],[2,\"Power (Watt) 46 - 63\",\"Power (Watt) 65 - 112\"],[3,\"Revolution (RPM) 57 - 58\",\"Revolution (RPM) 57 - 59\"],[4,\"Endurance (51-75% of VO2Max)\",\"Endurance (51-75% of VO2Max)\"],[5,\"HR (Bpm) 157 - 161\",\"HR (Bpm) 163 - 168\"],[6,\"Power (Watt) 114 - 125\",\"Power (Watt) 129 - 141\"],[7,\"Revolution (RPM) 59 - 62\",\"Revolution (RPM) 58 - 60\"],"

    tables_data = nil
    num_tables = tables_data[/#{"//"}(.*?)#{"//"}/m, 1].to_i
    tables_data.slice!("//#{num_tables}//")
    tables = {}
    (1..num_tables).each_with_index do |index|
      type = tables_data[/#{"//"}(.*?)#{"//"}/m, 1]
      tables_data.slice!("//#{type}//")
      data = tables_data.split("//").first
      tables["#{type}_#{index}"] = data
      tables_data.slice!(data)
    end

    tables.each do |key, value|
      value = value.tr('[]','')
      if key.include? "table"
        temp = value.split(",").map{ |i| JSON.parse(i)}.each_slice(6).to_a
        tables["#{key}"] = temp
      else
        temp = value.split(",").map{ |i| JSON.parse(i)}.each_slice(3).to_a
        tables["#{key}"] = temp
      end
    end

  end
end




