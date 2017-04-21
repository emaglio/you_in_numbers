module Report::Lib
  class OpenFileException
    extend Uber::Callable
    def self.call(options, *)
      raise ApplicationController::OpenFileException
    end
  end
end
