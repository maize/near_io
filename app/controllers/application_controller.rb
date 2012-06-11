class ApplicationController < ActionController::Base
	protect_from_forgery

	def home
		@place = Place.new
		render "layouts/home"
	end
end