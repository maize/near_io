# Load the rails application
require File.expand_path('../application', __FILE__)
require File.dirname(__FILE__) + '/../lib/classes/foursquare_api.rb'
require File.dirname(__FILE__) + '/../lib/classes/instagram_api.rb'

# Initialize the rails application
NnApi::Application.initialize!