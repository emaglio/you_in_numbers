require 'test_helper.rb'

class ReportOperationTest < MiniTest::Spec
  let(:upload_file) { ActionDispatch::Http::UploadedFile.new({
                        :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
                      })
                    }
  let(:params_pass) { { } }
  let(:attrs_pass) { { } }
  let(:cpet_file_path) { upload_file }

  describe 'invalid input' do

    it 'populates ' do

    end

  end

end
