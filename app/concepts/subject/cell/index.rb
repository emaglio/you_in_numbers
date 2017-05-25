module Subject::Cell

  class Index < Trailblazer::Cell

    def subject_array
      array = []

      model.each do |subject|
        str = "["
        str = str + ("#{subject.firstname.inspect}")
        str = str + (",")
        str = str + ("#{subject.lastname.inspect}")
        str = str + (",")
        str = str + ("#{subject.dob.strftime("%d %B %Y").inspect}")
        str = str + (",")
        str = str + ("#{subject.height.to_s.inspect}")
        str = str + (",")
        str = str + ("#{subject.weight.to_s.inspect}")
        str = str + ("]")
        str = str + (",")
        array << str
      end

      return array
    end

  end # class Index

end # module Subject::Cell
