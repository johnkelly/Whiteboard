if Rails.env.production?
  PUSHER_PUBLIC_KEY = ENV['PUSHER_PUBLIC_KEY']

  Pusher.app_id = ENV['PUSHER_APP_ID']
  Pusher.key = PUSHER_PUBLIC_KEY
  Pusher.secret = ENV['PUSHER_SECRET_KEY']
else
  pusher_yaml_file = YAML.load_file Rails.root.join("config/pusher.yml")
  PUSHER_PUBLIC_KEY = pusher_yaml_file["pusher_public_key"]

  Pusher.app_id = pusher_yaml_file["pusher_app_id"]
  Pusher.key = PUSHER_PUBLIC_KEY
  Pusher.secret = pusher_yaml_file["pusher_secret_key"]
end