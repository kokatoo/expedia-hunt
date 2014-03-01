class RemoveUserFromSearch < ActiveRecord::Migration
  def up
    remove_column :searches, :user
  end

  def down
    add_column :searches, :user, :boolean, default: false
  end
end
