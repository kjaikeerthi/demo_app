class TestMailer < ActionMailer::Base
  default from: "from@example.com"

  def send_email(hash)
    @hash = hash
    mail(:to => @hash[:to], :subject => @hash[:subject])
  end
end
