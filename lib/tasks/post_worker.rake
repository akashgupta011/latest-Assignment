namespace :post_worker do
  desc 'Send CSV of posts created before 12:00 PM'
  task send_csv: :environment do
    posts_created_before_12pm = Post.where('created_at < ?', Time.zone.today.beginning_of_day + 12.hours)
    csv_data = posts_created_before_12pm.to_csv
    filename = "posts_created_before_12pm-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv"
    File.write(filename, csv_data)

    # You can add any additional logic here, such as sending the file via email or storing it in a specific location.
    # Example: EmailWorker.perform_async(filename)
  end
end