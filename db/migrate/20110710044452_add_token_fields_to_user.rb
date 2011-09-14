class AddTokenFieldsToUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :sfdc_token, :string
  	add_column :users, :sfdc_refresh_token, :string
  end

  def self.down
  	remove_column :users, :sfdc_token
  	remove_column :users, :sfdc_refresh_token
  end
end
