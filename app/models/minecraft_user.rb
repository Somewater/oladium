require "open-uri"

class MinecraftUser < ActiveRecord::Base
  attr_accessible :login, :password, :server, :session, :session_start
  
  def self.haspaid(username)
    URI.parse("https://www.minecraft.net/haspaid.jsp?user=#{username}").read == 'true'
  end
end
