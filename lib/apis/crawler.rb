=begin
Crawls websites, stores to MongoDB based.
=end

require 'anemone'  
require 'open-uri'  
require 'mongo'

include Mongoid::Timestamps # adds automagic fields created_at, updated_at

class Apis::Crawler

def spider(url, place)

  options = { 
     :duration => 5,
     :accept_cookies => true,
     :read_timeout => 20,
     :retry_limit => 0,
     :verbose => true,
     :discard_page_bodies => true,
     :obey_robots_txt => true
     :depth_limit => 3
   }

  begin
      Anemone.crawl(url, options) do |anemone|
          anemone.storage = Anemone::Storage.MongoDB
          puts "crawling #{url}"    
          anemone.on_every_page do |page|
                    if page.doc
                      title = page.doc.at('title').text
                      meta_desc = page.doc.css("meta[name='description']").first 
                      content = meta_desc['content'] 

                        if((content =~ /#{tag}/) or (title =~ /#{tag}/))
                          news = Newsitem.new(
                          {
                          :title => page.css("title").text   
                          :url => page.url
                          :siteId => source
                          }
                        else
                            puts "No match for #{place} indexed." 
                        end     
                    end
            end
          end
      end 
    end
  

  def spider_list(list, place)
    list.each do |page|
      item.spider(page, place)
    end
  end
