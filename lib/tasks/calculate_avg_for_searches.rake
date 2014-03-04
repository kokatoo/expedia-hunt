namespace :db do
	desc "calculate averages for searches"
	task calculate_avg: :environment do
		Search.all.each do |search|
			n = 0
			total = 0
			search.sub_searches.each do |sub_search|
				sub_search.flights.each do |flight|

					if flight.price && flight.timelines.size == 1
						# puts "flight: "
						# p flight.price
						# p flight.timelines.size
						# p total
						# p n
						# puts ""
						total += flight.price
						n += 1
					end
				end
			end

			if n != 0
				search.avg_direct_price = total.to_i / n
				p search.avg_direct_price
				search.save!
			else
				puts n
				p total
			end
		end
	end
end