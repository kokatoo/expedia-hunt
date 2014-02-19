class Search < ActiveRecord::Base
	attr_accessible :title, :end, :min, :max, :source, :destination, :start

	has_many :sub_searches
	has_many :flights

	def self.duplicate(search)
		search_dup = search.dup
		search_dup.version = search.version + 1

		search_dup
	end
end
