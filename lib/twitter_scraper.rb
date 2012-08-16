require 'rubygems'
require 'tweetstream'
require 'logger'
require 'mongo'
require 'time'
require 'pusher'

@logger = Logger.new STDERR

ERROR_TIMEOUT = 300             #in seconds, how long do we wait if Twitter rejects us

# Tweets from (Picadilly Circus)
@from_lat = 51.510042794076
@from_lng = -0.13391156241932
radius = 0.001 # catch area in degrees lat/lng

# Config
consumer_key        = "Q3ZYaHBA499Gt7UvGleHA"
consumer_secret     = "j7mlRh7rSMp25fpECVHEcTUzg2ezyomnEIwYqSnE"
oauth_token         = "15094851-0rINJgT7ILnOMpIUiqzNkHkx8UHOzm6MUeRGsTbi2"
oauth_token_secret  = "aPcC8jHyvVJnulVU2jzlDFUGpLaQ4o8jtBimHqKHag"

TweetStream.configure do |config|
  config.consumer_key = consumer_key
  config.consumer_secret = consumer_secret
  config.oauth_token = oauth_token
  config.oauth_token_secret = oauth_token_secret
  config.auth_method = :oauth
  config.parser = :yajl
end

Pusher.app_id = '25695'
Pusher.key = '63dd24301f53a7908733'
Pusher.secret = 'cf472b0e2c0721cb93e6'

# Bounding box
N = @from_lat + radius
S = @from_lat - radius
E = @from_lng + radius
W = @from_lng - radius

def parse_tweet status
  if status[:coordinates] and status[:coordinates][:type] == 'Point'
    lng, lat = status[:coordinates][:coordinates]

    data = {
		"twitter_id" => status[:id],
		"handle" => status[:user][:screen_name],
		"handle_id" => status[:user][:id],
		"text" => status[:text],
		"location" => status[:coordinates][:coordinates]
    }

    if    lng < [E, W].max \
      and lng > [E, W].min \
      and lat < [N, S].max \
      and lat > [N, S].min

      @logger.info "Got one from @#{status[:user][:screen_name]}:"
      @logger.info "\t#{status[:id]}: \"#{status[:text]}\""

      # if not status[:in_reply_to_user_id] \
      #   and not status[:retweeted] \
      #   and status[:entities][:user_mentions].empty?
      @logger.info "Saving tweet.."
      @collection.insert(data);
      # else
      #   @logger.info "Didn't save - tweet was mention, retweet, reply, or spammy."
      #   @logger.info "In reply to: " + status[:in_reply_to_user_id].inspect
      #   @logger.info "Retweeted? " + status[:retweeted].inspect
      #   @logger.info "Mentioned: " + status[:entities][:user_mentions].inspect
      # end
    else
      km_away = Math.sqrt(((lat - @from_lat) * 111)**2 + ((lng - @from_lng) * 79)**2)
      @logger.info "Tweet not within bounding box:\t#{km_away} km away."
    end

	Pusher['tweets_channel'].trigger('got_tweet', data)
  end
rescue Exception => ex
  @logger.error ex.message
  @logger.error ex.backtrace.join "\n"
end

client = TweetStream::Daemon.new('twitter_scraper', { log_output: true })
client.on_error { |message| @logger.error message }
client.on_reconnect { |timeout, retries| @logger.error "Reconnect: timeout = #{timeout}, retries = #{retries}" }

# mongodb://dev:Nearnote12@ds035997.mongolab.com:35997/near_io_dev
@db = Mongo::Connection.new("ds035997.mongolab.com", "35997").db("near_io_dev")
@db.collection("tweets")
@auth = @db.authenticate("dev", "Nearnote12")
@collection = @db.collection("tweets")

# Start filtering based on location
begin
	@logger.info "Starting up Twitter Scraper..."
	# Get only happy tweets :)
	# client.filter({:track => [":)"], :locations => ["#{W},#{S},#{E},#{N}"]}) do |status|
	# 	parse_tweet status
	# end

	# Filter method
	# client.filter({:locations => ["#{W}","#{S}","#{E}","#{N}"]}) do |status|
	# 	parse_tweet status
	# end

	# Locations method
	client.locations("#{W},#{S},#{E},#{N}") { |status| parse_tweet status }
rescue HTTP::Parser::Error => ex
  # Although TweetStream should recover from
  # disconnections, it fails to do so properly.
  @logger.error "HTTP Parser error encountered - let's sleep for #{ERROR_TIMEOUT}s."
  @logger.error ex.message
  @logger.error ex.backtrace.join "\n"
  sleep ERROR_TIMEOUT
  retry
end