class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :uname
      t.string :uemail
      t.string :token
      t.string :token_secret
      t.string :token_refresh

      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
