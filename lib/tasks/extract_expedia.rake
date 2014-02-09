require 'open-uri'

namespace :db do
	desc "populating expedia"
	task load_flights: :environment do
		agent = Mechanize.new
		agent.get("http://www.expedia.ca/Flights")

		form = agent.page.form_with(class: 'flightOnly')
		form["TripType"] = "RoundTrip"
		form["FrAirport"] = "Shanghai, China (SHA-All Airports)"
		form["ToAirport"] = "Vancouver, BC, Canada (YVR-All Airports)"
		form["FromDate"] = "27/02/2014"
		form["ToDate"] = "26/03/2014"

		form.submit
		url = "http://www.expedia.ca/Flight-Search-Outbound?#{agent.page.search('form#flightResultForm')[0]['action'].split('?')[1]}"
		p url

	  json = JSON.load(open(url))
	  json["searchResultsModel"]["offers"][0..5].each do |result|
	  	begin
	  		leg = result["legs"][0]
	  		price = leg["price"]
	  		p price["formattedTotalPrice"]

	  		timelines = leg["timeline"]
	  		timelines.each do |timeline|
	  			if timeline.has_key?("carrier")
	  				p timeline["carrier"]["airlineName"]
	  				departure = timeline["departureAirport"]["longName"]
	  				arrival = timeline["arrivalAirport"]["longName"]
	  				p "From #{departure} to #{arrival}"
	  			else
	  				start_time = timeline["startTime"]
	  				end_time = timeline["endTime"]
	  				p "Layover #{start_time['dateLongStr']} #{start_time['time']} to #{end_time['dateLongStr']} #{end_time['time']}"
	  			end
	  		end
	  	rescue Exception => e
	  		puts e.message
	  	end
	  end
	end
end