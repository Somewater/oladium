# encoding: utf-8

require 'digest/md5'

class MinecraftGateApplication
  class << self
    def call(env)
      request = Rack::Request.new(env)
      method = request.path
      method = /\/.+\/(?<method>.+)(\?.+)?/.match(method)[:method] rescue nil

      response = case method
                  when 'login'
                    login(request)
                  when 'session'
                    session(request)
                  when 'joinserver'
                    joinserver(request)
                  when 'checkserver'
                    checkserver(request)
                  when 'minecraft_skins'
                    minecraft_skins(request)
                  else
                    'Wrong path'
                end
      
      [200, { "Content-Type" => "text/plain; charset=utf-8" }, [response]]
    rescue  => ex
      Rails.logger.warn "MinecraftGate error: #{ex}\n#{ex.backtrace("\n")}"
    end
    
    def login(request)
      login = request.params['user'].to_s
      password = request.params['password'].to_s
      version = request.params['version'].to_i
      return 'Old version' if version < 13
      return 'Bad login' if login.size == 0 || password.size == 0
      user = MinecraftUser.where(:login => login).first
      if(user && user.password == Digest::MD5.hexdigest(password))
        session = generate_session()
        user.session_start = Time.new
        user.session = session
        user.save
        [(Time.new.to_i * 1000).to_s, 'deprecated', login, session, ''].join(':')
        # $gamebuild.':'.md5(login).':'.$login.':'.$sessid.':'
        # 1374223516000:deprecated:somewater156:6169455662781693089:50a4628068014e088d26014a7cf13041 (6169455662781693089 - sessionID, negative too)
      else
        'Bad login'
      end
    end

    def session(request)
      login = request.params['name'].to_s
      session = request.params['session'].to_s
      user = MinecraftUser.where(:login => login, :session => session).first
      if user
        user.session_start = Time.new
        user.save
      end
      "--"
    end    
    
    def joinserver(request)
      login = request.params['user'].to_s
      session = request.params['sessionId'].to_s
      server = request.params['serverId'].to_s
      
      user = MinecraftUser.where(:login => login, :session => session).first
      if(user && server.size > 0)
        if(user.server != server)
          user.server = server
          user.save
        end
        return 'OK'
      end
      "Bad login" 
    end
    
    def checkserver(request)
      login = request.params['user'].to_s
      server = request.params['serverId'].to_s
      if(MinecraftUser.where(:login => login, :server => server).limit(1).exists?)
        "YES"
      else
        "NO"
      end
    end
    
    def minecraft_skins(request)
      'Unimplemented method minecraft_skins'
    end   
    
    private
    def generate_session
      magic = 0xAABBCC
      (rand(2147483647) + 1000000000).to_s << (rand(2147483647) + 1000000000).to_s << magic.to_s 
    end
  end
end