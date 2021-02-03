# frozen_string_literal: true

require 'test_helper'

class ReportOperationTest < MiniTest::Spec
  let(:upload_file) do ActionDispatch::Http::UploadedFile.new(
    :tempfile => File.new(Rails.root.join('test/files/cpet.xlsx'))
  )
  end
  let(:params_pass) { {} }
  let(:attrs_pass) { {} }
  let(:cpet_file_path) { upload_file }

  describe 'invalid input' do
    it 'populates ' do
    end
  end
end
