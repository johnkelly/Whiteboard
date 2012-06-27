if Rails.env.production?
  # heroku set credentials from ENV hash
  Stripe.api_key = ENV['STRIPE_API_KEY']
  STRIPE_PUBLIC_KEY = ENV['STRIPE_PUBLIC_KEY']
else
  # get credentials from YML file
  stripe_yaml_file = YAML.load_file Rails.root.join("config/stripe.yml")
  Stripe.api_key = stripe_yaml_file["stripe_api_key"]
  STRIPE_PUBLIC_KEY = stripe_yaml_file["stripe_public_key"]
end