module Aggregator
  class MochiAggregator < Aggregator

    NET = 'mochi'

    attr_accessor :search, :category, :tag, :response, :limit

    default_timeout 5

    def load()
      query = {:format => 'json', :limit => (@limit ? @limit : 20)}
      query[:search] = @search if @search
      query[:tag] = @tag if @tag
      response = self.class.get("http://www.mochimedia.com/feeds/games/#{CONFIG['mochi']['publicher_id']}/#{(@category ? @category : '')}",
                                :query => query)
      if((200..299).include? response.code)
        data = JSON.parse(response.body)
        data['games'].each do |game_data|
          g = ::Aggregator::Game.new
          g.net = NET
          g.net_id = game_data['game_tag']
          # :net, :net_id, :title, :description, :body, :type, :width, :height, :image, :tags
          g.title = game_data['name']
          g.description = game_data['description']
          g.body = game_data['swf_url']
          g.type = ::Game::TYPE_EMBED
          g.width = game_data['width']
          g.height = game_data['height']
          g.image = game_data['thumbnail_url']
          g.tags = game_data['tags'].join(',')
          @games << g
        end
      end
    end
  end
end