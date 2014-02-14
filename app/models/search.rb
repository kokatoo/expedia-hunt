class Search < ActiveRecord::Base
	attr_accessible :title, :start, :min, :max, :source, :destination

	has_many :flights
end
