module Subject::Cell

  class Index < Trailblazer::Cell

    def subject_array
      array = []

      model.each do |subject|
        array2 = []
        array2 << subject.firstname.inspect
        array2 << subject.lastname
        array2 << subject.height.to_s
        array2 << subject.weight.to_s
        array << array2
      end

      return array
    end

  end # class Index

end # module Subject::Cell
