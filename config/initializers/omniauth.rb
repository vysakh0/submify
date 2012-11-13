OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, YOUR_APP_ID, YOUR_APP_SECRET
end
