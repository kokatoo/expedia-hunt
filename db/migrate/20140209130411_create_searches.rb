class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
    	t.string :title, null: false
    	t.datetime :start, null: false
    	t.integer :min, null: false
    	t.integer :max, null: false

    	t.string :source
    	t.string :destination

      t.timestamps
    end
  end
end
