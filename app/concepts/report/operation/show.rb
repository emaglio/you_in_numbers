class Report::Show < Trailblazer::Operation
  step Model(Report, :find_by)
  failure :not_found!, fail_fast: true
  step Policy::Pundit( ::Session::Policy, :report_owner?)
  failure Session::Lib::ThrowException
  step :check_params!

  def not_found!(options, *)
    options["not_found"] = true
  end

  def check_params!(options, model:, current_user:, **)
    current_user.content["report_settings"]["params_list"].each do |param|
      if !model.cpet_params.include? param
        options["param_not_found"] = param
        break
      end
    end

    current_user.content["report_settings"]["ergo_params_list"].each_with_index do |param, index|
      if !model.cpet_params.include? param and (index == 0 or index == 2)
        options["param_not_found"] = param
        break
      end
    end
  end
end
