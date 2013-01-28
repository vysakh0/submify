ActionMailer::Base.smtp_settings = {
  address: "smtp.zoho.com",
  port:  587,
  domain: 'submify.com',
  authentication: 'plain',
  enable_starttls_auto: true, 
  user_name: 'support@submify.com',
  password:  '9381205918'
}
