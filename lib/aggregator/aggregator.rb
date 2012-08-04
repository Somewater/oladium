require "httparty"

module Aggregator

  class Aggregator

    include HTTParty

    # как параметры передаем параметры поиска
    def initialize()
      @games = []
    end

    # заполнить геймами
    def load
    end

    def games
      @games
    end

  end


  class Game
    attr_accessor :net, :net_id, :title, :description, :body, :type, :width, :height, :image, :tags

    # создать ::Game
    def to_game(*args)
      if args.length  == 1 && args.first.is_a?(::Game)
        g = args.first
      else
        g = ::Game.new(*args)
      end
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
      g
    end
  end

  def self.mochi
    MochiAggregator.new
  end
end