module Report::Cell

  class Item < Trailblazer::Cell

    def link
        link_to model.title, report_path(model)
    end

    def delete
      link_to '    <i class="fa fa-times" style="color:red;"></i>'.html_safe, report_path(model.id),
        method: :delete, data: { confirm: 'Are you sure?' }
    end

  end # class Item

end # module Report::Cell
