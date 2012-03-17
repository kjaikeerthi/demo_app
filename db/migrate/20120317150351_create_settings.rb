class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name, :null => false
      t.string :imap, :null => false
      t.integer :port, :default => 993, :null => false
      t.references :project
      t.timestamps
    end
  end
end
