# Load the rails application
require File.expand_path('../application', __FILE__)

require "yaml"
CONFIG = YAML.load(File.read("#{Rails.root}/config/config.yml"))

# Initialize the rails application
Oladium::Application.initialize!
