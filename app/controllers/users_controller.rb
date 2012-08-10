class UsersController < ApplicationController
	def likes
		@user = User.find(params[:id])
		@likes = @user.facebook_likes
	    respond_to do |format|
	      format.html # index.html.erb
	      format.json { render :json => @likes }
	    end
	end

	def following_places
		@user = User.find(params[:id])
		@places = @likes.following_places
	    respond_to do |format|
	      format.html # index.html.erb
	      format.json { render :json => @places }
	    end
	end
end
