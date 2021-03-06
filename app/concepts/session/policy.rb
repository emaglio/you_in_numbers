class Session::Policy
  def initialize(user, model)
    @user = user
    @model = model
  end

  attr_reader :user

  delegate :admin?, to: :user

  def true?
    true
  end

  def company_owner?
    return unless @user
    @user.id == @model.user_id
  end

  def report_owner?
    return true if @model.user_id == 1 # this is to edit the report template using the Dummy report id = 1
    company_owner?
  end

  def subject_owner?
    company_owner?
  end

  def update_delete_report?
    post_owner? or admin?
  end

  def current_user?
    return unless @user
    @user.email == @model.email
  end

  def signed_in?
    @user
  end

  def show_block_user?
    current_user? or admin?
  end
end
