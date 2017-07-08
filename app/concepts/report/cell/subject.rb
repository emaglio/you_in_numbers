module Report::Cell

  class Subject < New

    def subject
      ::Subject.find_by(id: model.subject_id)
    end

  end # class Subject

end # module Report::Cell
