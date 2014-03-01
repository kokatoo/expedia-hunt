require 'resque/errors'

class ExpediaSearch
	@queue = :expedia_queue

	def self.perform(search_id)

		old_search = Search.find(search_id)
		search = Search.duplicate(old_search)
		
		(search.min..search.max).each do |num|
			sub_search = SubSearch.new()
			sub_search.start = search.start
			sub_search.end = search.start + num.days
			sub_search.source = search.source
			sub_search.destination = search.destination

			sub_search.load_flights()
			if sub_search.flights.size > 0
				prices = sub_search.flights.pluck("price")
				sub_search.min_price = prices.min
				sub_search.max_price = prices.max

				sub_search.save!

				search.sub_searches << sub_search
			end
		end

		search.save!
	end
end