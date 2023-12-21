# config/schedule.rb

# Run a task every 2 minutes
every 2.minutes do
  runner 'puts "I am cronjob"'
end

# Run a Rake task every day at 1:00 am
every 1.day, at: '1:00 am' do
  rake 'post_worker:send_csv'
end

# Run a Rake task every day at 4:30 am
every 1.day, at: '4:30 am' do
  rake 'email:send_daily_report'
end

# Run a Rake task every day at 12:30 pm
every 1.day, at: '12:30 pm' do
  rake 'post:send_daily_report'
end

# Run a Sidekiq worker job every day at 12:05 pm
every 1.day, at: '12:05 pm' do
  runner 'DailyReportWorker.perform_async'
end
