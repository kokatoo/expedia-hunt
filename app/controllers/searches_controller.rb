require 'will_paginate/array'
require 'resque'

class SearchesController < ApplicationController
	def index
		@searches = Search.searches
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
		@search = Search.find(params[:id])

		old_search = Search.duplicate(@search)
		old_search.save!

		@search.sub_searches.clear
		@search.searches << old_search
		
		start = @search.start
		until(start > @search.end) do
			Resque.enqueue(ExpediaSearch, @search.id, start.to_s)
			start = start + 1.day
		end

		redirect_to @search
	end

	def show
		@search = Search.find(params[:id])
		@search.sub_searches.sort! { |x, y| x.min_price <=> y.min_price }

		@currency = "USD"
	end
end
