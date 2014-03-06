namespace :db do
	desc "run expedia search"
	task run_search: :environment do
		Search.where("search_id is null").each do |search|
			old_search = Search.duplicate(search)

			search.sub_searches.clear
			search.searches << old_search
			search.save!

			start = search.start
			until(start > search.end) do
				Resque.enqueue(ExpediaSearch, search.id, start.to_s)
				start = start + 1.day
			end
		end
	end
end