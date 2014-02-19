class AddSubSearchIdToFlights < ActiveRecord::Migration
  def change
    add_column :flights, :sub_search_id, :integer

    add_index :flights, :sub_search_id
  end
end