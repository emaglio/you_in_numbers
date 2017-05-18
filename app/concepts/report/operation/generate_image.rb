class Report::GenerateImage < Trailblazer::Operation
  step Model(Report, :find_by)
  step Policy::Pundit( ::Session::Policy, :report_company_owner? )
  failure ::Session::Lib::ThrowException
  step :generate_image!
  failure :error!

  def generate_image!(options, params:, **)
    return false if params[:error]
    file = File.open("#{Rails.root}/public/temp_files/image-#{params[:index]}.png", "wb")
    file.write(params[:image].read)
  end

  def error!(options, *)
    options["error"] = "Something went wrong"
  end

end # class Report::GenerateImage
