class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
    	t.string :airline
    	t.datetime :start, null: false
    	t.datetime :end, null: false
    	t.boolean :layover, null: false
    	t.string :departure, null: false
    	t.string :arrival, null: false
    	t.references :flight

      t.timestamps
    end

    add_index :timelines, :flight_id
  end
end
