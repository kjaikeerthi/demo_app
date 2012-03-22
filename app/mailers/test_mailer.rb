class TestMailer < ActionMailer::Base
  default from: "from@example.com"

  def send_email(hash)
    @hash = hash
    binding.pry
    mail(:to => @hash[:to], :subject => @hash[:subject])
  end
end
