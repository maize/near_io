require 'anemone'
require 'system'
require 'mongo'

class Apis::Crawler

site_root = 

# MONGODB
db = Mongo::Connection.new.db("blogposts")
posts_collection = db["posts"]

# SPIDER 
def spider(url, duration=60)
   options = 
   { 
     :accept_cookies => true,
     :read_timeout => 20,
     :retry_limit => 0,
     :verbose => true,
     :discard_page_bodies => true,
     :user_agent => 'Mozilla...'
   }
   
begin
     # Stop crawl after n seconds
     SystemTimer.timeout_after(duration) do
       Anemone.crawl(self, options) do |anemone|
         anemone.storage = Anemone::Storage.MongoDB()
         anemone.focus_crawl 

         
         anemone.on_every_page do |page|
           puts page.url
           doc = page.doc
           yield doc if doc
         end
       end
     end
   rescue Timeout::Error
   end
 end

   check_for_term
   
# DISCARD BODY
Anemone.crawl(url,:discard_page_bodies=> true)

# FOR BLOGS   
Anemone.crawl(domain, :depth_limit => 1) do |anemone|

# FOR NEWS SITES
Anemone.crawl(domain, :depth_limit => 3) do |anemone|
