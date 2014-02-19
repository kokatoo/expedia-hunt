require 'will_paginate/array'

class SearchesController < ApplicationController
	def index
		@searches = Search.all
	end

	def new
		@search = Search.new
	end

	def edit
		@search = Search.find(params[:id])
	end

	def create
		@search = Search.new(params[:search])

		if @search.save
			flash[:notice] = "Search has been created."
			redirect_to @search
		else
			flash[:alert] = "Search has not been created."
			render action: "new"
		end
	end

	def update
		@search = Search.find(params[:id])

		if @search.update_attributes(params[:search])
			flash[:notice] = "Search has been updated"
			redirect_to @search
		else
			flash[:alert] = "Search has not been updated"
			render action: "edit"
		end
	end

	def start
		@old_search = Search.find(params[:id])
		@search = Search.duplicate(@old_search)

		(@search.min..@search.max).each do |num|
			sub_search = SubSearch.new()
			sub_search.start = @search.start
			sub_search.end = @search.start + num.days
			sub_search.source = @search.source
			sub_search.destination = @search.destination

			sub_search.load_flights()
			prices = sub_search.flights.pluck("price")
			sub_search.min_price = prices.min
			sub_search.max_price = prices.max

			sub_search.save!

			@search.sub_searches << sub_search
		end

		@search.save!

		redirect_to @search
	end

	def show
		@search = Search.find(params[:id])
		@search.sub_searches.sort! { |x, y| x.min_price <=> y.min_price }

		@currency = "USD"
	end
end
