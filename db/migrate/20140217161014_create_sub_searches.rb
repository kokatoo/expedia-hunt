class CreateSubSearches < ActiveRecord::Migration
  def change
    create_table :sub_searches do |t|
    	t.datetime :start, null: false
    	t.datetime :end, null: false
    	t.string :source
    	t.string :destination

    	t.references :search

      t.timestamps
    end

    add_index :sub_searches, :search_id
  end
end
