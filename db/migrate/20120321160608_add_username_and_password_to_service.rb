class AddUsernameAndPasswordToService < ActiveRecord::Migration
  def up
    add_column :services, :username, :string
    add_column :services, :password, :string
    add_column :services, :setting_id, :integer
  end
 
  def down
    remove_column :services, :username
    remove_column :services, :password
    remove_column :services, :setting_id
  end
end
