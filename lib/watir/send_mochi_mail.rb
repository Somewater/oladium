# encoding: utf-8

class SendMochiMail

  attr_reader :browser

  def initialize()
    require 'watir'
    @browser = Watir::Browser.start "http://www.mochimedia.com/"
    @browser.link(:text, "Log In").click
    @browser.text_field(:id, 'email').set('mktsz@mail.ru')
    @browser.text_field(:id, 'password').set('adelaida')
    @browser.button(:text, 'Login').click
  end

  def email(user_link, title, body)
    #@browser.goto "https://www.mochimedia.com/community/profile/Evil-Dog"
    @browser.goto user_link
    @browser.link(:text, "Private Message").click
    @browser.text_field(:id, "msg_subject").set(title)
    @browser.text_field(:id, "msg_body").set(body)
    @browser.button(:id, "b_send").click
  end

  def process_games(games)
    data = JSON.parse games.first.net_data
    game_names = games.map(&:title).join(', ')
  end

  def generate_file
    authors = {}
    Game.find_each do |game|
      net_data = JSON.parse(game.net_data)
      author = net_data['author']
      author_link = net_data['author_link']
      authors[author] = [author_link] unless authors[author]
      authors[author] << Developer.find_by_login(author).sig
      authors[author] << game.title
    end
    File.open('authors.txt', 'w') do |f|
      authors.each do |author, data|
        f.puts [author].concat(data).join(';;;;')
      end
    end
  end

  def process_file(file_name)
    File.open(file_name) do |f|
      f.each_line do |line|
        arr = line.split(';;;;')
        author = arr[0]
        author_link = arr[1]
        sig = arr[2]
        games = arr.drop(3)
        email(author_link, "Your game#{games.size > 1 ? 's' : ''} publishing", get_message(author, games, sig))
      end
    end
  end

  def get_message(author, games, sig)
    s = games.size > 1 ? 's' : ''
    m = <<-MSG
Hello!
As you probably know Mochigames finalizing distribution of games in the coming days (http://mochiland.com/articles/mochi-media-winding-down-services-end-date-of-3-31-2014).
Your game#{s} #{games.map{|g| '"' + g + '"'}.join(', ')} is published on our web site oladium.com and we offer further cooperation in distribution of the game#{s}.
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