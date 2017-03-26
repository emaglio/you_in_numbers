module Report::Cell

  class Index < Trailblazer::Cell
    
    def total
      model.size
    end

  end
  
end