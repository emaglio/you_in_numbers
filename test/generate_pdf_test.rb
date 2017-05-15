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
    image "#{Rails.root.join("public/") + @model.logo[:thumb].url}", :position => :left, :vposition => :top, :fit => [@logo_size,@logo_size]
  end

  def write_chart_0
    image "#{Rails.root.join("public/temp_files/image-0.png")}", :fit => [@chart_size,@chart_size]
  end

  def write_chart_1
    image "#{Rails.root.join("public/temp_files/image-1.png")}", :fit => [@chart_size,@chart_size]
  end

  def write_chart_2
    image "#{Rails.root.join("public/temp_files/image-2.png")}", :fit => [@chart_size,@chart_size]
  end

  def write_chart_3
    image "#{Rails.root.join("public/temp_files/image-3.png")}", :fit => [@chart_size,@chart_size]
  end
end

class GeneratehvPDF < MiniTest::Spec

  it "description" do
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})["model"]

    company = Company::Create.({ user_id: user.id, name: "My Company", address_1: "address 1", address_2: "address 2", city: "Freshwater", postcode: "2096", country: "Australia",
                                  country: "Australia", email: "company@email.com", phone: "12345", website: "wwww.company.com.au", logo: File.open("test/images/logo.jpeg")
                                }, "current_user" => user)["model"]

    upload_file = ActionDispatch::Http::UploadedFile.new({
      :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
    })
    report = Report::Create.({user_id: user.id, title: "Report", cpet_file_path: upload_file, template: "default"}, "current_user" => user)
    report.success?.must_equal true

    path = "./test/greetings.pdf"

    greeter = Header.new(company)
    greeter.write_details
    greeter.write_logo
    greeter.write_chart_0
    greeter.write_chart_1
    greeter.write_chart_2
    greeter.write_chart_3
    greeter.save_as(path)

    # result = Report::GenerateFile.({id: report["model"].id}, "current_user" => user)
    # result.success?.must_equal true
  end
end




