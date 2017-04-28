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

upload_file = ActionDispatch::Http::UploadedFile.new({
      :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
    })

report = Report::Create.({
      user_id: -1,
      title: "My report",
      cpet_file_path: upload_file
  }, "current_user" => admin)
