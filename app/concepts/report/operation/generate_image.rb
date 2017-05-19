class Report::GenerateImage < Trailblazer::Operation
  step Model(Report, :find_by)
  step Policy::Pundit( ::Session::Policy, :report_company_owner? )
  failure ::Session::Lib::ThrowException
  step :create_folder!
  step :generate_image!
  failure :error!

  def create_folder!(options, *)
    #TODO: create folder related with subject details and report ID in order to use to save/delete images
    return true
  end

  def generate_image!(options, params:, **)
    return false if params[:error]
    file = File.open("#{Rails.root}/public/temp_files/image-#{params[:index]}.png", "wb")
    file.write(params[:image].read)
  end

  def error!(options, *)
    options["error"] = "Something went wrong"
  end

end # class Report::GenerateImage
