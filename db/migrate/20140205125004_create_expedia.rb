class CreateExpedia < ActiveRecord::Migration
  def change
    create_table :expedia do |t|

      t.timestamps
    end
  end
end
