namespace :post do
  desc 'Send daily post report email'
  task send_daily_report: :environment do
    PostsController.new.send_daily_report
  end
end