require "httparty"

module Aggregator

  class Aggregator

    include HTTParty

    # как параметры передаем параметры поиска
    def initialize()
      @games = []
    end

    # заполнить геймами
    def load(params)
      raise 'override me'
    end

    def from_net_category(name)
      raise 'override me'
    end

    def games
      @games
    end

    def total
      @games ? @games.size : 0
    end

    def offset
      0
    end

    def query
      ''
    end

  end


  class Game
    attr_accessor :net, :net_id, :title, :description, :body, :type, :width, :height, :image, :tags, :category, :opts,
                  :query, :slug, :net_data

    def initialize
      @opts = {}
      @query = ''
    end

    # создать ::Game
    def to_game(*args)
      if args.length  == 1 && args.first.is_a?(::Game)
        g = args.first
      else
        g = ::Game.new(*args)
      end
      g.game_model = self
      g.net = self.net
      g.net_id = self.net_id
      g.title = self.title
      g.description = self.description
      g.body = self.body
      g.type = self.type
      g.width = self.width
      g.height = self.height
      g.image = self.image
      g.tags = self.tags
      g.category = self.category
      g.opts = self.opts if self.opts
      g.slug = self.slug
      g.net_data = self.net_data.to_json
      g
    end
  end

  def self.mochi
    MochiAggregator.new
  end
end