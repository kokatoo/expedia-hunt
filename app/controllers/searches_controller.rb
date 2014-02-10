require 'will_paginate/array'

class SearchesController < ApplicationController
	def index
		@searches = Search.all
	end

	def new
		@search = Search.new
	end
end
