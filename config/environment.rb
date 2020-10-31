require 'early'

Early do
  default :DOMAIN_NAME, 'youinnumbers.com'
end

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
