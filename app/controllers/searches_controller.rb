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

		@search.sub_searches.delete_all
		@search.searches << old_search
		@search.save!

		start = @search.start
		until(start > @search.end) do
			ExpediaSearch.enqueue(@search, start.to_s, @search.title.to_sym)
			start = start + 1.day
		end

		redirect_to @search
	end

	def show
		@search = Search.find(params[:id])
		@search.sub_searches.sort! do |x, y|
			x_min = x.min_direct_price
			y_min = y.min_direct_price
			if x_min && y_min
				x_min <=> y_min
			elsif x_min
				-1
			else
				1
			end
		end
		@avgs = []

		@search.searches.drop(1).each do |s|
			@avgs << s.avg_direct_price.to_f
		end
		@avgs << @search.avg_direct_price.to_f
		puts "========"
		p @avgs

		@currency = "USD"
	end
end
