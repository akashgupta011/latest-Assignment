class DailyReportWorker
  include Sidekiq::Worker

  def perform
    # Logic for generating PDF and sending email
    posts_created_after_12_pm = Post.where("created_at >= ?", Time.zone.now.beginning_of_day + 12.hours)

    if posts_created_after_12_pm.present?
      pdf_data = generate_pdf(posts_created_after_12_pm)
      send_email_with_pdf(pdf_data)
    end
  end

  private

  def generate_pdf(posts)
    respond_to do |format|
      format.html
      format.csv do
        posts_created_before_12pm = Post.where('created_at < ?', Time.zone.today.beginning_of_day + 12.hours)
        send_data posts_created_before_12pm.to_csv, filename: "posts_created_before_12pm-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv"
      end
    end
  end

  def send_email_with_pdf(pdf_data)
    @posts = Post.where("created_at >= ?", Time.zone.now.beginning_of_day)

    # Assuming you have a User model associated with posts
    recipients = User.where(role:"admin").pluck(:email).join(',')

    UserMailer.daily_post_report(recipients, @posts).deliver_now
  end
end