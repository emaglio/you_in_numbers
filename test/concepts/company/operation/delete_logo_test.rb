# frozen_string_literal: true

require 'test_helper'

class CompanyOperationDeleteLogoTest < MiniTest::Spec
  # it "wrong file type" do
  #   res, op = User::Operation::Create.run(user: attributes_for(:user,
  #     profile_image: File.open("test/files/wrong_file.docx"),
  #     cv: File.open("test/files/wrong_file.docx")))
  #   res.must_equal false
  #   op.errors.to_s.must_equal "{:profile_image=>[\"Invalid format, file should be one of: *./jpeg, *./jpg and "\
  #                             "*./png\"], :cv=>[\"Invalid format, file can be one only a PDF\"]}"
  #   Paperdragon::Attachment.new(op.model.image_meta_data).exists?.must_equal false
  #   Paperdragon::Attachment.new(op.model.file_meta_data).exists?.must_equal false
  # end

  # it "file too big" do
  #   res, op = User::Operation::Create.run(user: attributes_for(:user,
  #             cv: File.open("test/files/DLCO cal.pdf")))
  #   res.must_equal false
  #   op.errors.to_s.must_equal "{:cv=>[\"File too big, it must be less that 1 MB.\"]}"
  #   Paperdragon::Attachment.new(op.model.file_meta_data).exists?.must_equal false
  # end

  it 'delete logo' do
    user = User::Operation::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')['model']
    company = Company::Operation::Create.({
                                            user_id: user.id,
                                            name: 'New Company',
                                            logo: File.open('test/images/logo.jpeg')
                                          }, 'current_user' => user)
    _(company.success?).must_equal true

    _(Paperdragon::Attachment.new(company['model'].logo_meta_data).exists?).must_equal true

    # num_file = Dir["test/images/"].length
    # puts num_file.inspect

    delete_logo = Company::Operation::DeleteLogo.({ id: company['model'].id }, 'current_user' => user)
    _(delete_logo.success?).must_equal true

    company = Company.find_by(id: company['model'].id)

    _(Paperdragon::Attachment.new(company.logo_meta_data).exists?).must_equal false
  end
end
