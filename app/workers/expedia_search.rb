require 'resque/errors'

class ExpediaSearch
	@queue = :expedia_queue

	def self.perform(search_id, start)

		search = Search.find(search_id)
		start = Date.parse(start)
		(search.min..search.max).each do |num|
			sub_search = SubSearch.new()
			sub_search.start = start
			sub_search.end = start + num.days
			sub_search.source = search.source
			sub_search.destination = search.destination

			sub_search.load_flights()
			if sub_search.flights.size > 0
				prices = sub_search.flights.map(&:price)
				sub_search.min_price = prices.min
				sub_search.max_price = prices.max
				sub_search.save!

				search.sub_searches << sub_search
			end
		end

		search.save!
	end
end