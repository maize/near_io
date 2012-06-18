class NewsItemsController < ApplicationController
	def add
	end

	def show
    	@news_item = NewsItem.find(params[:id])
    	@bid = Bid.new
        respond_to do |format|
        	format.html # show.html.erb
        	format.json { render :json => @news_item }
        	format.xml { render :xml => @news_item }
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