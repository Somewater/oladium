module Aggregator
  class MochiAggregator < Aggregator

    NET = 'mochi'

    attr_accessor :search, :category, :tag, :response, :limit, :offset

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

    def initialize
      super
      @total = 0
      @offset = 0
      @query = ''
    end

    def load(params)
      self.category = params[:category] if params[:category].to_s.size > 0 && params[:category] != 'all'
      self.search = params[:search] if params[:search].to_s.size > 0
      self.tag = params[:tags] if params[:tags].to_s.size > 0
      self.limit = params[:limit].to_i if params[:limit].to_i > 0
      self.offset = params[:offset].to_i if params[:offset].to_i >= 0

      query = {:format => 'json', :limit => (@limit ? @limit : 20)}
      query[:search] = @search if @search
      query[:tag] = @tag if @tag
      query[:offset] = @offset if @offset
      @category = @@category_dict[@category].first if @category && @@category_dict[@category]
      @category = @@query_to_net_category.invert[@category] if @category && @@query_to_net_category.invert[@category]
      response = self.class.get("http://www.mochimedia.com/feeds/games/#{CONFIG['mochi']['publicher_id']}/#{(@category ? @category : '')}",
                                :query => query)
      if((200..299).include? response.code)
        data = JSON.parse(response.body)
        @total = data['total'].to_i
        @offset = data['offset'].to_i
        @query = {:search => @search, :tag => @tag, :category => @category, :limit => @limit, :offset => @offset}.to_json
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
          g.opts[:stage3d] = true if game_data['stage3d']
          g.query = @query
          @games << g
        end
      end

      self
    end

    def total
      @total
    end

    def offset
      @offset
    end

    def query
      @query
    end

    def from_net_category(name)
      name = (@@category_dict.find{|k,v| k if v.include?(name) }) || 'other'
      Category.find_by_name(name)
    end
  end
end