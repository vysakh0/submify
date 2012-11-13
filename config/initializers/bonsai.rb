ENV['ELASTICSEARCH_URL'] = ENV['BONSAI_URL']

# Optional, but recommended: use a single index per application per environment
app_name = Rails.application.class.parent_name.underscore.dasherize
app_env = Rails.env
INDEX_NAME = "#{app_name}-#{app_env}"
