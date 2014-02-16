class Search < ActiveRecord::Base
	attr_accessible :title, :end, :min, :max, :source, :destination, :start

	has_many :flights

	def self.duplicate(search)
		search_dup = search.dup
		search_dup.version = search.version += 1

		search_dup
	end

	def load_flight(result, url)
		flight = Flight.new()
  	flight.url = url
  	flight.start = self.start.strftime("%d/%m/%Y")
  	flight.end = (self.start + self.min.days).strftime("%d/%m/%Y")
  	flight.source = self.source
  	flight.destination = self.destination

		leg = result["legs"][0]
		flight.price = leg["price"]["offerPrice"]
		flight.currency = leg["price"]["localizedCurrencyCode"]

		flight
	end

	def load_timeline(timeline)
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

		tl
	end

	def load_timelines(flight, result)
		leg = result["legs"][0]

		timelines = leg["timeline"]
  		timelines.each do |timeline|
  			flight.timelines << load_timeline(timeline)
  		end
	end

	def load_flights
		agent = Mechanize.new
		# note the date format is different
		flight_url = "http://www.expedia.com/Flight-Search-All?action=FlightSearchAll%40searchFlights&origref=www.expedia.com%2FFlight-Search-All&inpFlightRouteType=2&inpDepartureLocations=#{CGI.escape self.source}&inpArrivalLocations=#{CGI.escape self.destination}&inpDepartureDates=#{CGI.escape self.start.strftime("%m/%d/%Y")}&inpArrivalDates=#{CGI.escape (self.start + self.min.days).strftime("%m/%d/%Y")}&inpAdultCounts=1&inpChildCounts=0&inpChildAges=-1&inpChildAges=-1&inpChildAges=-1&inpChildAges=-1&inpChildAges=-1&inpInfants=2&inpFlightAirlinePreference=&inpFlightClass=3"
		agent.get(flight_url)

		url = "http://www.expedia.com/Flight-Search-Outbound?#{agent.page.search('form#flightResultForm')[0]['action'].split('?')[1]}"
		json = JSON.load(open(url))

	  json["searchResultsModel"]["offers"][0..6].each_with_index do |result, index|
	  	flight = load_flight(result, url)
	  	load_timelines(flight, result)

  		flight.save!
  		self.flights << flight
	  end
	end
end
