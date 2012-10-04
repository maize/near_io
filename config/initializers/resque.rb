require 'resque_scheduler'
require 'resque_scheduler/server'

p "Loading Resque config.."

# rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
# rails_env = ENV['RAILS_ENV'] || 'development'

# resque_config = YAML.load_file(rails_root + '/config/resque.yml')
# Resque.redis = resque_config[rails_env]

ENV["REDISTOGO_URL"] ||= "redis://redistogo:0ee23116b741ef686b2f90e63de1a418@clingfish.redistogo.com:9074/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host =&gt; uri.host, :port =&gt; uri.port, :password =&gt; uri.password)