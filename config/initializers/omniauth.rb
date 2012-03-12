Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'EJZcBqApceb3x7FVPISZYA', 'M50ssoPQ0P6ODQfv1KPDrKOd0ZF1SrNwhbonaB8YOg'
  provider :facebook, '407536285938593', 'c77ae6e7772c5e8cff4b950d20829a61'
end
