class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :uid, :limit => 8
      t.string :provider
      t.string :auth_token
      t.string :auth_secret
      t.references :project
      t.timestamps
    end
  end
end
