class Developer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  if Rails.env.development?
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable
  else
    devise :database_authenticatable, :rememberable, :trackable, :validatable
  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :games

  attr_accessible :email, :login

  def sig
    require 'digest/sha2'
    Digest::SHA256.hexdigest(self.login + "_249328")[0..9]
  end
end