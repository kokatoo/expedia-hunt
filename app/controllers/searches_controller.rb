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
		@search = Search.find(params[:id])

		agent = Mechanize.new
		agent.get("http://www.expedia.com/Flights")

		form = agent.page.form_with(class: 'flightOnly')
		form["TripType"] = "RoundTrip"
		# form["FrAirport"] = @search.source
		# form["ToAirport"] = @search.destination
		# form["FromDate"] = @search.start.strftime("%d/%m/%Y")
		# form["ToDate"] = (@search.start + @search.min.days).strftime("%d/%m/%Y")
		form["TripType"] = "RoundTrip"
		form["FrAirport"] = "Shanghai, China (SHA-All Airports)"
		form["ToAirport"] = "Vancouver, BC, Canada (YVR-All Airports)"
		form["FromDate"] = "27/02/2014"
		form["ToDate"] = "26/03/2014"

		form.submit

		url = "http://www.expedia.com/Flight-Search-Outbound?#{agent.page.search('form#flightResultForm')[0]['action'].split('?')[1]}"
		puts "Flight URL: #{url}}"

	  json = JSON.load(open(url))

	  json["searchResultsModel"]["offers"][0..5].each_with_index do |result, index|
	  	flight = Flight.new()
	  	flight.url = url
	  	flight.start = form["FromDate"]
	  	flight.end = form["ToDate"]
	  	flight.source = form["FrAirport"]
	  	flight.destination = form["ToAirport"]

  		leg = result["legs"][0]
  		flight.price = leg["price"]["offerPrice"]
  		flight.currency = leg["price"]["localizedCurrencyCode"]

  		timelines = leg["timeline"]
  		timelines.each do |timeline|

  			tl = Timeline.new

  			if timeline.has_key?("carrier")
  				tl.layover = false

  				tl.airline = timeline["carrier"]["airlineName"]	  		
  				tl.departure = timeline["departureAirport"]["longName"]
  				tl.arrival = timeline["arrivalAirport"]["longName"]

  				start_time = timeline["departureTime"]
  				end_time = timeline["arrivalTime"]

  				tl.start = DateTime.parse("#{start_time["dateLongStr"]} #{start_time['time']}")
  				tl.end = DateTime.parse("#{end_time["dateLongStr"]} #{end_time['time']}")
  			else
  				tl.layover = true
  				tl.departure = timeline["airport"]["longName"]
  				tl.arrival = timeline["airport"]["longName"]

  				start_time = timeline["startTime"]
  				end_time = timeline["endTime"]

  				tl.start = DateTime.parse("#{start_time["dateLongStr"]} #{start_time['time']}")
  				tl.end = DateTime.parse("#{end_time["dateLongStr"]} #{end_time['time']}")
  			end
  			tl.save!
  			flight.timelines << tl
  		end
  		flight.save!
  		@search.flights << flight
  		p @search.flights
  		p flight
  		@search.save!
	  end

		redirect_to @search
	end

	def show
		@search = Search.find(params[:id])
	end
end
