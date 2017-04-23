class Company::DeleteLogo < Trailblazer::Operation
  step Model(Company, :find_by)
  step Policy::Pundit( ::Session::Policy, :report_company_owner?)
  failure Session::Lib::ThrowException
  step :delete_logo!
  step :save!

  def delete_logo!(options, model:, **)
    model.logo do |v|
      v.delete!
    end
  end

  def save!(options, model:, **)
    model.save
  end

end # class Company::DeleteLogo
