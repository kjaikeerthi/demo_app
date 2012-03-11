class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :uid
      t.string :provider
      t.string :auth_token
      t.string :auth_secret
      t.references :user
      t.timestamps
    end
  end
end
