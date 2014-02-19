class AddMinMaxPriceToSubSearch < ActiveRecord::Migration
  def change
    add_column :sub_searches, :min_price, :decimal, precision: 8, scale: 2
    add_column :sub_searches, :max_price, :decimal, precision: 8, scale: 2
  end
end
