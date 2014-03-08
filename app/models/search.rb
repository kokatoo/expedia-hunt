class Search < ActiveRecord::Base
	attr_accessible :title, :end, :min, :max, :source, :destination, :start

	belongs_to :search
	has_many :searches
	has_many :sub_searches, dependent: :destroy
	has_many :flights

	scope :searches, where(search_id: nil)

	def self.duplicate(search)
		search_dup = search.dup
		search.version += 1

		search.save!
		search_dup.save!

		search_dup
	end
end
