class Timeline < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :flight
end
