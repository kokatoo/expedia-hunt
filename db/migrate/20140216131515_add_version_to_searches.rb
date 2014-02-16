class AddVersionToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :version, :integer, default: 0
    Search.update_all('version=0')
  end
end
