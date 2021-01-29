class User::UpdateTable < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model(User, :find_by)
    step Policy::Pundit(::Session::Policy, :current_user?)
    failure ::Session::Lib::ThrowException
    step Contract::Build(constant: User::Contract::EditTable)
  end # class Present

  step Nested(Present)
  step Contract::Validate()
  step :update_table!
  step Contract::Persist()

  def update_table!(_options, model:, params:, **)
    obj_array = model.content['report_template']['custom']

    index = params['edit_table'].to_i

    obj_array[index][:title] = params['title']
    obj_array[index][:params_list] = params['params_list']
    obj_array[index][:params_unm_list] = params['unm_list']

    true
  end
end # class User::EditChart
