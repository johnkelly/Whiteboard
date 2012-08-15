if Rails.env.production?
  Pusher.app_id = ENV['PUSHER_APP_ID']
  Pusher.key = ENV['PUSHER_PUBLIC_KEY']
  Pusher.secret = ENV['PUSHER_SECRET_KEY']
else
  pusher_yaml_file = YAML.load_file Rails.root.join("config/pusher.yml")

  Pusher.app_id = pusher_yaml_file["pusher_app_id"]
  Pusher.key = pusher_yaml_file["pusher_public_key"]
  Pusher.secret = pusher_yaml_file["pusher_secret_key"]
end