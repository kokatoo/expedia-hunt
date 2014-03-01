class AddUserToSearch < ActiveRecord::Migration
  def up
    add_column :searches, :user, :boolean, default: false

    Search.update_all(user: true)
  end

  def down
  	remove_column :searches, :user
  end
end
