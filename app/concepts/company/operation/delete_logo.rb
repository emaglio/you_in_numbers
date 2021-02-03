class Company::Operation::DeleteLogo < Trailblazer::Operation
  step Model(Company, :find_by)
  step Policy::Pundit(::Session::Policy, :company_owner?)
  failure Session::Lib::ThrowException
  step :delete_logo!
  step :save!

  def delete_logo!(_options, model:, **)
    model.logo do |v|
      v.delete!
    end
  end

  def save!(_options, model:, **)
    model.save
  end
end # class Company::Operation::DeleteLogo
