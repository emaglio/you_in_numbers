module Report::Cell

  class Item < Trailblazer::Cell

    def link
        link_to model.title, report_path(model)
    end

  end # class Item <

end # module Report::Cell
