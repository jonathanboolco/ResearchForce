# == Schema Information
# Schema version: 20110510030131
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
require 'digest'
class User < ActiveRecord::Base

  #attr_accessible :name, :email,
  #,:password, :password_confirmation
  has_many :services, :dependent => :destroy
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates_uniqueness_of :user_id  
  validates :name, :presence => true,:length => {:maximum => 50}       
  validates :email, :presence => true,:format   => { :with => email_regex }

  # Automatically create the virtual attribute 'password_confirmation'.  
  #validates :password, :presence => true,:confirmation => true,:length => { :within => 6..40 }
              
  before_save :save_salt

  # Return true if the user's password matches the submitted password.  
  #def has_password?(submitted_password)
    #encrypted_password == encrypt(submitted_password)
  #end
  
 #def self.authenticate(email, submitted_password)
   # user = find_by_email(email)
   # return nil if user.nil?
   # return user if user.has_password?(submitted_password)    
  #end

  def self.authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
  end
      
  private
  
  #def encrypt_password
    #self.salt = make_salt if new_record?
    #self.encrypted_password = encrypt(password)
  #end
  
  #def encrypt(string)
    #secure_hash("#{salt}--#{string}")
  #end

  def save_salt
    self.salt = make_salt if new_record?
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{user_id}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  
end
