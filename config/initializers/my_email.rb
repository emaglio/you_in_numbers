require "tyrant/operation/mailer"

Tyrant::Mailer.class_eval do
  def email_options!(options, *)
    Pony.options = {
                      :from => "admin@youinnumbers.com",
                      :via => :smtp,
                      :via_options => {
                        :address              => 'smtp.gmail.com',
                        :port                 => '587',
                        :enable_starttls_auto => true,
                        :user_name            => ENV['GMAIL_EMAIL'],
                        :password             => ENV['GMAIL_APP_PASSWORD'],
                        :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
                        :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
                      }

                    }
  end
end
