require 'puma'

workers_count = ENV.fetch('PUMA_WORKERS', 1).to_i
threads_count = ENV.fetch('PUMA_THREADS', 16).to_i

workers workers_count
threads 1, threads_count

environment ENV.fetch('RAILS_ENV', 'production')

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

# Set up socket location
bind "unix://#{shared_dir}/sockets/puma.sock"

# Logging
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
activate_control_app

on_worker_boot do
 require "active_record"
 ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
 ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end
