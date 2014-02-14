require 'will_paginate/array'

class SearchesController < ApplicationController
	def index
		@searches = Search.all
	end

	def new
		@search = Search.new
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
			redirect_to @car
		else
			flash[:alert] = "Search has not been updated"
			render action: "edit"
		end
	end

	def start
		@search = Search.find(params[:id])

		

		redirect_to search
	end

	def show
		@search = Search.find(params[:id])
	end
end
