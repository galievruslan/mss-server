require 'ostruct'
require 'yaml'

APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
AppConfig = OpenStruct.new(APP_CONFIG)
