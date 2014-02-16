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
		@search = @old_search.dup
		@search.version = @old_search.version += 1

		agent = Mechanize.new
		# note the date format is different
		flight_url = "http://www.expedia.com/Flight-Search-All?action=FlightSearchAll%40searchFlights&origref=www.expedia.com%2FFlight-Search-All&inpFlightRouteType=2&inpDepartureLocations=#{CGI.escape @search.source}&inpArrivalLocations=#{CGI.escape @search.destination}&inpDepartureDates=#{CGI.escape @search.start.strftime("%m/%d/%Y")}&inpArrivalDates=#{CGI.escape (@search.start + @search.min.days).strftime("%m/%d/%Y")}&inpAdultCounts=1&inpChildCounts=0&inpChildAges=-1&inpChildAges=-1&inpChildAges=-1&inpChildAges=-1&inpChildAges=-1&inpInfants=2&inpFlightAirlinePreference=&inpFlightClass=3"
		agent.get(flight_url)

		url = "http://www.expedia.com/Flight-Search-Outbound?#{agent.page.search('form#flightResultForm')[0]['action'].split('?')[1]}"
		json = JSON.load(open(url))

	  json["searchResultsModel"]["offers"][0..5].each_with_index do |result, index|
	  	flight = Flight.new()
	  	flight.url = url
	  	flight.start = @search.start.strftime("%d/%m/%Y")
	  	flight.end = (@search.start + @search.min.days).strftime("%d/%m/%Y")
	  	flight.source = @search.source
	  	flight.destination = @search.destination

  		leg = result["legs"][0]
  		flight.price = leg["price"]["offerPrice"]
  		flight.currency = leg["price"]["localizedCurrencyCode"]

  		timelines = leg["timeline"]
  		flight.timelines = []
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
