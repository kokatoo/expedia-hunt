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
	  p json
	end
end