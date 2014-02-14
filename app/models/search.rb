class Search < ActiveRecord::Base
	attr_accessible :title, :end, :min, :max, :source, :destination, :start

	has_many :flights
end
