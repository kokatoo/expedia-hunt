class Flight < ActiveRecord::Base
	attr_accessible :url, :start, :end, :price, :currency, :layover

	has_many :timelines
end
