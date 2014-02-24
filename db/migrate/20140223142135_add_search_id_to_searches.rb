class AddSearchIdToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :search_id, :integer

    add_index :searches, :search_id
  end
end
