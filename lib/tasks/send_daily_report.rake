namespace :email do
  desc 'Send daily report email'
  task send_daily_report: :environment do
    UserMailer.daily_report.deliver_now
  end
end