# frozen_string_literal: true
# require 'test_helper.rb'

# class GeneratehvPDF < MiniTest::Spec

#   let(:user) {(User::Operation::Create.({email: "test@email.com", password: "password", confirm_password: "password"}))["model"]}

#   it "some" do
#     user.email.must_equal "test@email.com"

#     form = User::Contract::EditTemplate.new(user)
#     form.validate(id: user.id, "type" => "VO2max summary", "index" => "0")

#     form.content.report_template.default.each do |obj|
#       puts obj.inspect
#     end

#     puts "---------".inspect

#     form.content.report_template.custom.each do |obj|
#       puts obj.inspect
#     end
#     puts "-----after----".inspect

#     form.content.report_template.custom = add_element(form.content.report_template.custom)
#     form.content.report_template.default = form.content.report_template.default

#     form.save

#     form.content.report_template.default.each do |obj|
#       puts obj.inspect
#     end

#     puts "---------".inspect

#     form.content.report_template.custom.each do |obj|
#       puts obj.inspect
#     end

#   end

#   def add_element(array)
#     index = 0
#     obj_array = array

#     types = {
#       "VO2max summary" => MyDefault::ReportObj[2],
#       "Training Zones" => MyDefault::ReportObj[3],
#       "Chart" => MyDefault::ReportObj[0]
#       }

#     obj = types["VO2max summary"]
#     obj_array.insert(index, obj)

#     # update index
#     for i in (index+1)..(obj_array.size-1)
#       obj_array[i][:index] += 1
#     end

#     obj_array[index][:index] = index

#     return obj_array
#   end

# end
