class RemoveFlightsFromSearches < ActiveRecord::Migration
  def change
  	remove_column :searches, :flights
  end
end
