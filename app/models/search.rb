class Search < ActiveRecord::Base
	attr_accessible :title, :end, :min, :max, :source, :destination, :start

	belongs_to :search
	has_many :searches, :dependent => :delete_all
	has_many :sub_searches, :dependent => :delete_all
	has_many :flights, :dependent => :delete_all

	scope :searches, where(search_id: nil)

	def self.duplicate(search)
		search_dup = search.dup
		search_dup.version = search.version + 1

		search_dup
	end
end
