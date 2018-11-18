module Session::Lib
  class ThrowException
    extend Uber::Callable
    def self.call(_options, current_user:, **)
      current_user ? (raise ApplicationController::NotAuthorizedError) : (raise ApplicationController::NotSignedIn)
    end
  end
end
