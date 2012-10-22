class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email,              :null => false, :default => ""
      t.string :username
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.integer :sex
      t.date :birthdate

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
