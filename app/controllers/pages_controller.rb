class PagesController < ApplicationController
  require 'yaml'
  def index    
  end
  
  def bali
    @setting = YAML.load_file("#{Rails.root}/config/settings.local.yml")
  end
end
