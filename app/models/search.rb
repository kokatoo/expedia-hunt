class Search < ActiveRecord::Base
	attr_accessible :title, :end, :min, :max, :source, :destination, :start

	belongs_to :search
	has_many :searches
	has_many :sub_searches
	has_many :flights

	def self.duplicate(search)
		search_dup = search.dup
		search_dup.version = search.version + 1

		search_dup
	end
end
