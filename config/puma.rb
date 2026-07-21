threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
threads threads_count, threads_count

port ENV.fetch("PORT", 3000)
environment ENV.fetch("RAILS_ENV", "development")

worker_count = ENV.fetch("WEB_CONCURRENCY", 0).to_i
if worker_count.positive?
  workers worker_count
  preload_app!
end

plugin :tmp_restart
