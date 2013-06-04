#raw_config = File.read("#{Rails.root}/config/app_config.yml")

#APP_CONFIG = YAML.load(raw_config)["all"].symbolize_keys.merge(YAML.load(raw_config)[ENV].symbolize_keys)
#APP_CONFIG = YAML.load(raw_config)[ENV]
APP_CONFIG = YAML.load_file("#{Rails.root}/config/app_config.yml")[Rails.env].symbolize_keys
