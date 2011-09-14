class SfFieldToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :nickname, :string
  	add_column :users, :picture, :string
  	add_column :users, :thumbnail, :string
  	add_column :users, :user_id, :string
  	add_column :users, :language, :string
  	add_column :users, :utcOffset, :integer
  	add_column :users, :last_modified_date, :datetime
  	add_column :users, :profile, :string
  	add_column :users, :active, :boolean
  	add_column :users, :user_type, :string
  	add_column :users, :last_status_body, :string
  	add_column :users, :last_status_created_date, :datetime
  	add_column :users, :org_id, :string

  end

  def self.down
  	remove_column :users, :nickname
  	remove_column :users, :picture
  	remove_column :users, :thumbnail
  	remove_column :users, :user_id
  	remove_column :users, :language
  	remove_column :users, :utcOffset
  	remove_column :users, :last_modified_date
  	remove_column :users, :profile
  	remove_column :users, :active
  	remove_column :users, :user_type
  	remove_column :users, :last_status_body
  	remove_column :users, :last_status_created_date
  	remove_column :users, :org_id
  end
end