class Company::Operation::Delete < Trailblazer::Operation
  step Model(Company, :find_by)
  step Policy::Pundit(::Session::Policy, :company_owner?)
  fail Session::Lib::ThrowException
  step :delete_logo!
  step :delete!

  def delete_logo!(_ctx, model:, **)
    return true if model.logo_meta_data == nil
    model.logo do |v|
      v.delete!
    end
  end

  def delete!(_ctx, model:, **)
    model.destroy
  end
end # class Company::Operation::Delete
