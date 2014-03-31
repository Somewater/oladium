# encoding: utf-8

class MochiGameActualizer
  include Sidekiq::Worker

  sidekiq_options :retry => 3

  def perform(game_id)
    game = Game.find(game_id)
    data = JSON.parse game.net_data
    base_path = "#{Rails.public_path}/games"
    image_path = "#{base_path}/#{game.image}"
    swf_path = "#{base_path}/#{game.body}"

    if File.basename(game.body) == 'main.swf'
      FileDiffDownloader.perform_async(data['swf_url'], swf_path, game_id)
    end
  end
end
