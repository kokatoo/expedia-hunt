require 'open-uri'

namespace :db do
	desc "update search url"
	task update_url: :environment do
		Search.all.each do |search|
			if true#search.url.blank?
				agent = Mechanize.new
				agent.get("http://www.expedia.com.sg")#{}"http://www.expedia.com/Flights")

				form = agent.page.form_with(class: 'flightOnly')
				form["TripType"] = "RoundTrip"
				form["FrAirport"] = "Shanghai, China (SHA-All Airports)"
				form["ToAirport"] = "Vancouver, BC, Canada (YVR-All Airports)"
				form["FromDate"] = "27/02/2014"
				form["ToDate"] = "26/03/2014"

				form.submit
				puts "=========="
				p agent.page
				url = "http://www.expedia.com/Flight-Search-Outbound?#{agent.page.search('form#flightResultForm')[0]['action'].split('?')[1]}"
			end
		end
	end

	desc "load hints" 
	task load_hints: :environment do
		url = "http://suggest.expedia.com/hint/es/v2/ac/en_CA/shanghai?lob=FLIGHTS&format=json&dest=false"
		html = open(url)
		p html.read.scan(/\"l\":\"(.*?)\",\"ll\"/)
	end
	desc "populating expedia"
	task load_flights: :environment do
		agent = Mechanize.new
		agent.get("http://www.expedia.com/Flights")

		form = agent.page.form_with(class: 'flightOnly')
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

	  	puts "Option #{index}"
	  	begin
	  		leg = result["legs"][0]

	  		price = leg["price"]	  		
	  		flight.price = price["offerPrice"]
	  		flight.currency = price["localizedCurrencyCode"]
	  		puts "Price: #{price["formattedTotalPrice"]} #{flight.currency}"

	  		timelines = leg["timeline"]
	  		timelines.each do |timeline|
	  			puts "\n"
	  			tl = Timeline.new

	  			if timeline.has_key?("carrier")
	  				tl.layover = false

	  				tl.airline = timeline["carrier"]["airlineName"]
	  				puts "Airline: #{tl.airline}"

	  				tl.departure = timeline["departureAirport"]["longName"]
	  				tl.arrival = timeline["arrivalAirport"]["longName"]

	  				start_time = timeline["departureTime"]
	  				end_time = timeline["arrivalTime"]

	  				tl.start = DateTime.parse("#{start_time["dateLongStr"]} #{start_time['time']}")
	  				tl.end = DateTime.parse("#{timeline["end_time"]} #{end_time['time']}")

	  				puts "From #{tl.departure} to #{tl.arrival}"
	  				puts "#{tl.start} to #{tl.end}"
	  			else
	  				tl.layover = true
	  				tl.departure = timeline["airport"]["longName"]
	  				tl.arrival = timeline["airport"]["longName"]

	  				start_time = timeline["startTime"]
	  				end_time = timeline["endTime"]

	  				tl.start = DateTime.parse("#{start_time["dateLongStr"]} #{start_time['time']}")
	  				tl.end = DateTime.parse("#{timeline["end_time"]} #{end_time['time']}")

	  				puts "Layover"
	  				puts "#{tl.start} to #{tl.end}"
	  			end
	  			# tl.save!
	  			flight.timelines << tl
	  		end

	  		flight.save!
	  		puts "\n\n"
	  	rescue Exception => e
	  		puts e.message
	  	end
	  end
	end
end