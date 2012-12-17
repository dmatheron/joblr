class FeedbackEmailMailer < ActionMailer::Base

  default from: "postman@joblr.co"
  layout 'mailers'

  def footer_form(feedback_email)
    @feedback_email = feedback_email
    @subject = @title = t('mailers.feedback_email.footer_form.subject', fullname: feedback_email.author.fullname)
  	@button  = { text: t('mailers.feedback_email.footer_form.button'), url: "mailto:#{feedback_email.author.email}?subject=RE: #{@subject}" }
    author = @feedback_email.author
    mail to: feedback_email.recipient_email, subject: t('mailers.feedback_email.footer_form.subject', fullname: author.fullname), reply_to: author.email
  end

  class Preview < MailView

    def footer_form
      name           = Faker::Name.name
      author         = FactoryGirl.create :author, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
      feedback_email = FactoryGirl.create :feedback_email, author: author
      email          = FeedbackEmailMailer.footer_form(feedback_email)
      email
    end
  end
end