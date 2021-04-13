ActionMailer::Base.add_delivery_method :smtp, Mail::SMTP,
  :address              => ENV['SMTP_HOST'],
  :port                 => ENV['SMTP_PORT'],
  :user_name            => ENV['SMTP_USERNAME'],
  :password             => ENV['SMTP_PASSWORD'],
  :authentication       => ENV['SMTP_AUTHENTICATION'],
  :enable_starttls_auto => true

