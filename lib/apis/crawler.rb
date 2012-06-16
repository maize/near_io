require 'anemone'  
require 'open-uri'  
require 'mongo'

class Apis::Crawler

def spider(url, place)

  options = { 
     :duration => 5,
     :accept_cookies => true,
     :read_timeout => 20,
     :retry_limit => 0,
     :verbose => true,
     :discard_page_bodies => true,
     :user_agent => 'Mozilla...'
   }

  Anemone.crawl(url, options) do |anemone|
      anemone.storage = Anemone::Storage.MongoDB
      puts "crawling #{url}"    
      anemone.on_every_page do |page|
        if( place =~ page.css("title") ) 
          puts page.css("title").text   
          puts page.url
            news = Newsitem.new(
            {
            :title => title,
            :url => url,
            :siteId => siteId
            }
          )
        end
      end
  end 
end

def spider_list(list, duration=)

  @array.each do |item|
    item.spider(self, place)
  end
end


### FOR API CONTORLLER

def get_local_blogs

end


def get_local_news



end
