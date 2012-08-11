require "tweetstream"

class TwitterScraper
	def initialize
		TweetStream.configure do |config|
		  config.consumer_key       = 'Q3ZYaHBA499Gt7UvGleHA'
		  config.consumer_secret    = 'j7mlRh7rSMp25fpECVHEcTUzg2ezyomnEIwYqSnE'
		  config.oauth_token        = '15094851-0rINJgT7ILnOMpIUiqzNkHkx8UHOzm6MUeRGsTbi2'
		  config.oauth_token_secret = 'aPcC8jHyvVJnulVU2jzlDFUGpLaQ4o8jtBimHqKHag'
		  config.auth_method        = :oauth
		end
	end

	def track_keywords(keywords)
		TweetStream::Client.new.track(keywords) do |status|
			p "#{status.text}"
		end
	end

	def parse_tweet(status)
		Rails.logger.info "[TweetStream] Status: #{status.id}"

		# Parse out the (structured) tweet message.
		# If the message is unstructured, discard it
		# Grab only tweets from foursquare
		if status[:source] && status[:source].include?('foursquare')
		    # Parse out the location name from the tweet
		    matching = /I'm at (.*?) (\(|w\/|http)/.match(status[:text])
		    matching ||= /\(@ (([^w]|w[^\/])*)(w\/.*)?\)/.match(status[:text])
			# matching ||= /the mayor of (.*) on @foursquare/.match(status[:text])

		    if matching
		      status[:name] = matching[1]
		    end

		    status[:url] = /(http:\/\/[^ ]*)$/.match(status[:text])
		    if status[:url]
		      status[:url] = status[:url][1]
		    end

		    #ap status
		    if status[:name] && status[:place] && status[:user] && status[:geo] && status[:geo][:coordinates]
				# Checkin.create(
				#   :place_id   => status[:place][:id],
				#   :place_name => status[:name].strip,
				#   :post_date  => DateTime.parse(status[:created_at]),
				#   :url        => status[:url],
				#   :user_id    => status[:user][:id_str],
				#   :latitude   => status[:geo][:coordinates][0],
				#   :longitude  => status[:geo][:coordinates][1]
				# )
				Rails.logger.info "[TweetStream] Adding checkin: #{status[:name].strip}"
				puts status.strip
		    end
		end
	end

	def track_keywords_nearby(longitude, latitude)
		@from_lng = longitude
		@from_lat = latitude
		radius = 0.001 # catch area in degrees lat/lng

		# Let's make us a bounding box to give Twitter's streaming API
		@N = @from_lat + radius
		@S = @from_lat - radius
		@E = @from_lng + radius
		@W = @from_lng - radius

		# TweetStream::Daemon.new('tracker', { ARGV: ['start'] })
		client = TweetStream::Daemon.new('twitter_scraper', { ARGV: ['start'], log_output: true })
		client.locations(@W,@S,@E,@N) { |status| parse_tweet status }

		# TweetStream::Client.new.locations(locations,
		#   :delete    => Proc.new { |status_id, user_id|
		#     Rails.logger.info "[TweetStream] Requesting to delete: #{status_id}"
		#   },
		#   :limit     => Proc.new { |skip_count|
		#     Rails.logger.info "[TweetStream] Limiting: #{skip_count}"
		#   },
		#   :error     => Proc.new { |message|
		#     Rails.logger.info "[TweetStream][#{Time.now}] TweetStream error: #{message}"
		#   },
		#   :reconnect => Proc.new { |timeout, retries|
		#     Rails.logger.info "[TweetStream][#{Time.now}] Reconnect: #{timeout} secs on #{retries} retry"
		#   }
		# ) do |status|
		# 	parse_tweet(status)
		# end
	end

	def start_daemon
		TweetStream::Daemon.new('tracker', { ARGV: ['start'] }).track('olympics', 'london') do |status|
			# end.filter({"locations" => "-12.72216796875, 49.76707407366789, 1.977539, 61.068917"}) do |status|
		end
	end
end