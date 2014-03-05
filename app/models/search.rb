class Search < ActiveRecord::Base
	attr_accessible :title, :end, :min, :max, :source, :destination, :start

	belongs_to :search
	has_many :searches, :dependent => :delete_all
	has_many :sub_searches, :dependent => :delete_all
	has_many :flights, :dependent => :delete_all

	scope :searches, where(search_id: nil)

	def self.duplicate(search)
		search_dup = search.dup
		search.version += 1

		search.sub_searches.each do |sub_search|
			search_dup.sub_searches << sub_search
		end

		search.save!
		search_dup.save!

		search_dup
	end
end
