class Company::Operation::DeleteLogo < Trailblazer::Operation
  step Model(Company, :find_by)
  step Policy::Pundit(::Session::Policy, :company_owner?)
  fail Session::Lib::ThrowException
  step :delete_logo!
  step :save!

  def delete_logo!(_ctx, model:, **)
    model.logo do |v|
      v.delete!
    end
  end

  def save!(_ctx, model:, **)
    model.save
  end
end # class Company::Operation::DeleteLogo
