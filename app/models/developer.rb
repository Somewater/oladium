class Developer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:email_or_login]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :login, :email_or_login

  attr_accessor :email_or_login
  has_many :games

  def sig
    require 'digest/sha2'
    Digest::SHA256.hexdigest(self.login + "_249328")[0..9]
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if email_or_login = conditions.delete(:email_or_login)
      where(conditions).where(["lower(login) = :value OR lower(email) = :value", { :value => email_or_login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
