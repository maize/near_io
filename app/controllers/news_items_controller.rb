class NewsItemsController < ApplicationController
	def show
    	@news_item = NewsItem.find(params[:id])
    	@bid = Bid.new
        respond_to do |format|
        	format.html # show.html.erb
        	format.json { render :json => @news_item }
        	format.xml { render :xml => @news_item }
      	end
	end

	def new
		@news_item = NewsItem.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render :json => @news_item }
		end
	end	

	def create
		@news_item = NewsItem.new
		@news_item.name = params[:news_item][:name]
		@news_item.url = params[:news_item][:url]
		@news_item.author = params[:news_item][:author]
		@news_item.type = params[:type]

		@place = Place.find(params[:news_item][:places])
		@news_item.places.push(@place)

		respond_to do |format|
			if @news_item.save
				format.html { redirect_to @place, :notice => 'News Item was successfully created.' }
				format.json { render :json => @news_item, :status => :created, :location => @news_item }
			else
				format.html { render :action => "new" }
				format.json { render :json => @news_item.errors, :status => :unprocessable_entity }
			end
		end
	end

	def bid
		@news_item = NewsItem.find(params[:news_item])
		@bid_value = params[:bid][:price]
		@bid = Bid.new
		@bid.price = @bid_value
		@bid.news_item = @news_item
		@bid.save
		
		redirect_to @news_item
	end
end