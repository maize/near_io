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

	def track_keywords_nearby(longitude, latitude)
		TweetStream::Client.new.track() do |status|
			end.filter({"locations" => longitude+","+latitude}) do |status|
			p "#{status.text}"
		end
	end

	def start_daemon
		TweetStream::Daemon.new('tracker', { ARGV: ['start'] }).track('olympics', 'london') do |status|
			# end.filter({"locations" => "-12.72216796875, 49.76707407366789, 1.977539, 61.068917"}) do |status|
		end
	end
end