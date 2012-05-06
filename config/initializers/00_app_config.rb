CONFIG = YAML.load_file "#{Rails.root}/config/app_config.yml"
CONFIG['icecast']['full_url'] = "http://#{CONFIG['icecast']['host']}:#{CONFIG['icecast']['port']}"