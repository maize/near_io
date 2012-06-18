=begin
Crawls websites, stores to MongoDB based.
=end

require 'anemone'  
require 'open-uri'  
require 'mongo'

include Mongoid::Timestamps # adds automagic fields created_at, updated_at

class Apis::Crawler
 
sitelist = ['http://www.rudebaguette.com/2012/06/11/teleportd-leweb-ass',
      'http://thenextweb.com/events/2012/06/11/leweb-london-is-almost-here-and-you-can-win-a-free-ticket/',
      'http://mashable.com']
sitename = ['Rude Baguette',
      'The Next Web',
      'Mashable']

  bloglist = ["http://kentishtowner.co.uk"]

  blogname = ["The Kentishtowner"]

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

  def sitespider(url, place)

    begin
        Anemone.crawl(url, options) do |anemone|
            anemone.storage = Anemone::Storage.MongoDB
            puts "crawling #{url}"    
              anemone.on_every_page do |page|
                      if page.doc
                        title = page.doc.at('title').text
                        meta_desc = page.doc.css("meta[name='description']").first 
                        content = meta_desc['content'] 

                          if((content =~ /#{place}/) or (title =~ /#{place}/))
                            news = Newsitem.new(
                            {
                            :title => title   
                            :url => page.url
                            :content => sitelist[a]
                            :type => "Site"
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

  def blogspider(url, place)

    begin
        Anemone.crawl(url, options) do |anemone|
            anemone.storage = Anemone::Storage.MongoDB
            puts "crawling #{url}"    
              anemone.on_every_page do |page|
                      if page.doc
                        title = page.doc.at('title').text
                        meta_desc = page.doc.css("meta[name='description']").first 
                        content = meta_desc['content'] 

                          if((content =~ /#{place}/) or (title =~ /#{place}/))
                            news = Newsitem.new(
                            {
                            :title => title   
                            :url => page.url
                            :content => sitelist[a]
                            :type => "Blog"
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

    def spider_sitelist(sitelist, place)
      a = 0
      sitelist.each do |page|
        sitespider(page, place)
        a += 1
      end
    end

    def spider_bloglist(bloglist, place)
      a = 0 
      bloglist.each do |page|
        blogspider(page, place)
        a += 1
      end
    end


end