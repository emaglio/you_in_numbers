class Report::GenerateImage < Trailblazer::Operation
  step Model(Report, :find_by)
  step Policy::Pundit( ::Session::Policy, :report_company_owner? )
  failure ::Session::Lib::ThrowException
  step :generate_image!

  def generate_image!(options, params:, **)
    file = File.open("#{Rails.root}/public/temp_files/image-#{params[:index]}.png", "wb")
    file.write(params[:image].read)
  end

end # class Report::GenerateImage
