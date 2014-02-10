class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
    	t.string :url, null: false
    	t.decimal :price, null: false, precision: 8, scale: 2
    	t.string :currency, null: false

    	t.datetime :start, null: false
    	t.datetime :end, null: false
    	t.string :source
    	t.string :destination

    	t.references :search

      t.timestamps
    end

    add_index :flights, :search_id
  end
end
