class AddEndToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :end, :datetime
  end
end
