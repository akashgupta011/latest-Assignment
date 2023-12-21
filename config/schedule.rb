# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
every 2.minute  do
  runner puts "jhgfffn"
end
every 1.day, at: '1:00 am' do
  rake 'post_worker:send_csv'
end
every 1.day, at: '4:30 am' do
  rake "email:send_daily_report"
end
every 1.day, at: '12:30 pm' do
  rake "post:send_daily_report"
end
# while true
#   UserMailer.send_email
#   sleep(120)  # sleep for 2 minutes
# end

# Learn more: http://github.com/javan/whenever
