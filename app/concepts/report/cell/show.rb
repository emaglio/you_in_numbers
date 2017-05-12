module Report::Cell

  class Show < Trailblazer::Cell
    include ActionView::Helpers::FormOptionsHelper
    include ActionView::Helpers::FormTagHelper

    def current_user
      options[:context][:current_user]
    end

    def obj_array
      current_user.content["report_template"][model.content]
    end

  end #class Show

end
