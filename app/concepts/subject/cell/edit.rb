module Subject::Cell

  class Edit < New
    def dob
      (model.dob.is_a? String) ? model.dob : model.dob.strftime("%d %B %Y")
    end
  end # class Edit

end # module Subject::Edit
