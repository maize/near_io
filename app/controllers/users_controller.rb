class UsersController < ApplicationController
	load_and_authorize_resource

	# GET /users
	# GET /users.json
	def index
		@users = User.all

		respond_to do |format|
		  format.html # index.html.erb
		  format.json { render json: @users }
		end
	end

	def facebook
		@fb_users = FacebookUser.all.page params[:page]
	    respond_to do |format|
	      format.html # index.html.erb
	      format.json { render :json => @fb_users }
	    end
	end

	# GET /users/1
	# GET /users/1.json
	def show
		@user = User.find(params[:id])

		respond_to do |format|
		  format.html # show.html.erb
		  format.json { render json: @user }
		end
	end

	def make_admin
		@user = User.find(params[:id])
		@user.admin = true
		@user.save

		p @user

		# @user.update_attribute :admin, true

		# ability = Ability.new(@user)
  		# assert ability.can?(:manage, :all)

  		render :nothing => true
	end

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
