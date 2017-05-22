class SubjectsController < ApplicationController

  def new
    run Subject::New

    render Subject::Cell::New, result["contract.default"]
  end

  def create
    run Subject::Create do |result|
      flash[:success] = "Subject created!"
      return redirect_to "/subjects"
    end

    render Subject::Cell::New, result["contract.default"]
  end

  def index
    run Subject::index

    render Subject::Cell::Index, result["contract.default"]
  end
end
