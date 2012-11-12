Rails.application.config.middleware.use OmniAuth::Builder do
  YOUR_APP_ID = 295241533825642
  YOUR_APP_SECRET = "6be81d70c8df4705180ed8052d635c37"
  provider :facebook, YOUR_APP_ID, YOUR_APP_SECRET
end
