require 'omniauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :github, ENV['GITTER_KEY'], ENV['GITTER_SECRET']
end
