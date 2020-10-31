require 'puma'

environment ENV.fetch('RAILS_ENV')
workers_count = ENV.fetch('PUMA_WORKERS', 0).to_i
threads_count = ENV.fetch('PUMA_THREADS', 16).to_i

workers workers_count
threads threads_count, threads_count
port 3000
quiet
preload_app! if workers_count.positive?
