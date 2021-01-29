module User::Cell
  class Settings < Trailblazer::Cell
    def current_user
      options[:context][:current_user]
    end
  end # class ShowReportSettings
end # module User::Cell
