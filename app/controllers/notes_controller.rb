class NotesController < ApplicationController
  def show
  end

  def create
  end

  def edit
  end

  def crawl
	Anemone.crawl("http://events.ucl.ac.uk/") do |anemone|
	  anemone.on_every_page do |page|
	      puts page.url
	  end
	end
  end
end
