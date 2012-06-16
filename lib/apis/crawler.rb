require 'anemone'
require 'system'
require 'mongo'
require 'nokogiri'

class Apis::Crawler


urls = File.open("newssites.csv")

opts = {discard_page_bodies: true, skip_query_strings: true, depth_limit:2000, read_timeout: 10} 



in_domain?(uri) != true 


Anemone.crawl(url, options = opts) do |anemone|
    anemone.storage = Anemone::Storage.MongoDB



    anemone.on_every_page
      if page.title =~ ''
end

