class Flight < ActiveRecord::Base
	attr_accessible :url, :start, :end, :price, :currency, :layover

	belongs_to :search
	has_many :timelines

	def num_layovers
		timelines.select{ |timeline| timeline.layover == true }.size
	end
end
