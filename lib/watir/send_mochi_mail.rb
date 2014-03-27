# encoding: utf-8

class SendMochiMail

  attr_reader :browser

  def init()
    require 'watir'
    @browser = Watir::Browser.start "http://www.mochimedia.com/"
    @browser.link(:text, "Log In").click
    @browser.text_field(:id, 'email').set('mktsz@mail.ru')
    @browser.text_field(:id, 'password').set('adelaida')
    @browser.button(:text, 'Login').click

    require 'logger'
    @logger = Logger.new("#{Rails.root}/tmp/watir_send_mochi_mail.log")
  end

  def email(user_link, title, body)
    #@browser.goto "https://www.mochimedia.com/community/profile/Evil-Dog"
    @logger.info "Email start to '#{user_link}'"
    @browser.goto user_link

    stop_alerts!

    @browser.link(:text, "Private Message").click
    @browser.text_field(:id, "msg_subject").set(title)
    @browser.text_field(:id, "msg_body").set(body)
    @browser.button(:id, "b_send").click
    @logger.info "Emailed link '#{user_link}'"
    @browser.speed = :zippy
  end

  def stop_alerts!
    # don't return anything for alert
    @browser.execute_script("window.alert = function() {}")
    # return some string for prompt to simulate user entering it
    @browser.execute_script("window.prompt = function() {return 'my name'}")
    # return null for prompt to simulate clicking Cancel
    @browser.execute_script("window.prompt = function() {return null}")
    # return true for confirm to simulate clicking OK
    @browser.execute_script("window.confirm = function() {return true}")
    # return false for confirm to simulate clicking Cancel
    @browser.execute_script("window.confirm = function() {return false}")
  end

  def process_games(games)
    data = JSON.parse games.first.net_data
    game_names = games.map(&:title).join(', ')
  end

  def generate_file
    authors = {}
    ids = Game.where('developer_id IS NULL').pluck(:id)
    ids.each_slice.each do |slice_ids|
      Game.where(id: slice_ids).each do |game|
        net_data = JSON.parse(game.net_data)
        author = net_data['author']
        dev = Developer.find_by_login(author)
        if dev
          dev.games << game
        else
          dev = Developer.create(:login => author,:email => "#{author}@oladium.com", :password => 'oladium')
          dev.games << game

          author_link = net_data['author_link']
          authors[author] = [author_link] unless authors[author]
        end
        if authors[author]
          authors[author] << dev.sig
          authors[author] << game.title
        end
      end
    end
    File.open("authors-#{Time.new.day}.txt", 'w') do |f|
      authors.each do |author, data|
        f.puts [author].concat(data).join(';;;;')
      end
    end
  end

  def process_file(file_name = 'authors.txt')
    @browser.speed = :fast
    File.open(file_name) do |f|
      c = 0
      f.each_line do |line|
        arr = line.split(';;;;')
        author = arr[0]
        author_link = arr[1]
        sig = arr[2]
        games = arr.drop(3)
        email(author_link, "Publishing your game#{games.size > 1 ? 's' : ''}", get_message(author, games, sig))
        c += 1
        puts "#{c}) #{author} emailed"
      end
    end
  end

  def get_message(author, games, sig)
    s = games.size > 1 ? 's' : ''
    games = games.each_with_index.to_a.select{|g,idx| idx % 2 == 0}.map{|g,idx| g.strip}
    if games.size <= 3
      games_str = games.map{|g| '"' + g + '"'}.join(', ')
    else
      games_str = games.take(2).map{|g| '"' + g + '"'}.join(', ').to_s.dup + ", etc"
    end
    m = <<-MSG
Hello!
As you probably know Mochigames finalizing distribution of games in the coming days (http://mochiland.com/articles/mochi-media-winding-down-services-end-date-of-3-31-2014).
Your game#{s} #{games_str} is published on our web site http://oladium.com and we offer further cooperation in distribution of the game#{s}.
Please contact us or upload version of the game without integrated Mochi Ad. We accept games for publication with any built in ads.
Email for communication: games@oladium.com
Link to enter the profile on the site for game uploads (under development, will be available in the next few days) :
http://oladium.com/developers/sign_up?login=#{author}&sig=#{sig}

Best wishes,
Oladium administration
MSG
    m
  end
end