class User::EditObj < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit( ::Session::Policy, :current_user? )
  failure ::Session::Lib::ThrowException
  step :update_custom_template!
  step :save!

  def update_custom_template!(options, params:, model:, **)
    obj_array = model.content["report_template"]["custom"]

    if params["move_up"] != nil and params["move_up"].to_i > 0
      index = params["move_up"].to_i
      obj_array[index-1][:index] = index
      obj_array[index][:index] = index -1
      obj_array.insert(index-1, obj_array.delete_at(index))
    end

    if params["move_down"] != nil and params["move_down"].to_i < (obj_array.size-1)
      index = params["move_down"].to_i
      obj_array[index][:index] = index +1
      obj_array[index+1][:index] = index
      obj_array.insert(index+1, obj_array.delete_at(index))
    end

    model.content["report_template"]["custom"] = obj_array
  end

  def save!(options, model:, **)
    model.save
  end

end # class User::EditObj
