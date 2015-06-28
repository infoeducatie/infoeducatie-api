ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  :server            => ENV['AWS_SES_ENDPOINT'],
  :access_key_id     => ENV['AWS_SES_ACCESS_KEY'],
  :secret_access_key => ENV['AWS_SES_SECRET_KEY']
