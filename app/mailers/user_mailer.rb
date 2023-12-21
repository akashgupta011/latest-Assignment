class UserMailer < ApplicationMailer
default from: 'notifications@example.com'

  def self.send_email
    attachments[Post.to_csv] = File.read(Post.to_csv)
    @url  = 'http://example.com/login'
    mail(to: "akashgupta@blubirch.com", subject: Post.to_csv)
  end
  def daily_report
    mail(to: 'akashgupta@blubirch.com', subject: 'Daily Report', body: 'This is the body of the email.')
  end
  def daily_post_report(recipients, posts)
    @posts = posts

    mail(to: recipients, subject: 'Daily Post Report')
  end
end
