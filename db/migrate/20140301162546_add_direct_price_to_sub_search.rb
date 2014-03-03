class AddDirectPriceToSubSearch < ActiveRecord::Migration
  def change
    add_column :sub_searches, :min_direct_price, :decimal, precision: 8, scale: 2
    add_column :sub_searches, :max_direct_price, :decimal, precision: 8, scale: 2
  end
end
