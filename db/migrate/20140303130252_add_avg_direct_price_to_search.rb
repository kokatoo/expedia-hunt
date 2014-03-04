class AddAvgDirectPriceToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :avg_direct_price, :decimal, precision: 8, scale: 2
  end
end
