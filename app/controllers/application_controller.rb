class ApplicationController < ActionController::Base
	protect_from_forgery

	def home
		render "places/search"
	end
end