# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User::Create.({
                      firstname: "Admin",
                      lastname: "Imp",
                      email: "admin@email.com",
                      password: "Test1234",
                      confirm_password: "Test1234"})["model"]
puts "Admin account created successfully!" if admin.id

subject = Subject::Create.({
                          user_id: admin.id,
                          firstname: "Ema",
                          lastname: "Maglio",
                          gender: "Male",
                          dob: "01/01/1980",
                          height: "180",
                          weight: "80",
                          phone: "912873",
                          email: "s@e.com"
                          }, "current_user" => admin)["model"]
puts "Dummy Subject created successfully!" if subject.id

upload_file = ActionDispatch::Http::UploadedFile.new({
  :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
})

report = Report::Create.({
          user_id: admin.id,
          subject_id: subject.id,
          title: "My report",
          cpet_file_path: upload_file,
          template: "default"
      }, "current_user" => admin)["model"]
puts "Dummy Report created successfully!" if report.id
