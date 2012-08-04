module Aggregator
  class MochiAggregator < Aggregator

    NET = 'mochi'

    attr_accessor :search, :category, :tag, :response, :limit

    default_timeout 5

    @@category_dict = {
                        'action' => ['Action', 'Adventure', 'Rhythm'],
                        'puzzle' => ['Puzzles', 'Board Game', 'Casino', 'Education', 'Jigsaw'],
                        'simulation' => ['Driving', 'Sports'],
                        'shooter' => ['Fighting', 'Shooting'],
                        'strategy' => ['Strategy'],
                        'other' => ['Other', 'Rhythm', 'Dress Up', 'Customize']
                      }

    @@query_to_net_category = {
                                'action' => 'Action',
                                'adventure' => 'Adventure',
                                'board-game' => 'Board Game',
                                'casino' => 'Casino',
                                'driving' => 'Driving',
                                'dress-up' => 'Dress Up',
                                'fighting' => 'Fighting',
                                'puzzles' => 'Puzzles',
                                'customize' => 'Customize',
                                'shooting' => 'Shooting',
                                'sports' => 'Sports',
                                'other' => 'Other',
                                'strategy' => 'Strategy',
                                'education' => 'Education',
                                'rhythm' => 'Rhythm',
                                'jigsaw' => 'Jigsaw'
                              }

    def load()
      query = {:format => 'json', :limit => (@limit ? @limit : 20)}
      query[:search] = @search if @search
      query[:tag] = @tag if @tag
      @category = @@category_dict[@category].first if @category && @@category_dict[@category]
      @category = @@query_to_net_category.invert[@category] if @category && @@query_to_net_category.invert[@category]
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
          g.category = self.from_net_category(game_data['category'])
          @games << g
        end
      end
    end

    def from_net_category(name)
      name = (@@category_dict.find{|k,v| k if v.include?(name) }) || 'other'
      Category.find_by_name(name)
    end
  end
end