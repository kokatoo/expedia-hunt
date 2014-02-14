class FlightsController < ApplicationController
	def index
		@flights = Flight.all
	end

	def create
		@search = Search.find(params[:search_id])
		@flight = Flight.new(params[:flight])

		redirect_to searches_path
	end
end
