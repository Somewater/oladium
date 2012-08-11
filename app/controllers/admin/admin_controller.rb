module Admin
  class AdminController < ApplicationController
    before_filter :authenticate_user!
    layout 'admin_area'

    def index
      @path_by_action = {}
      self.action_methods.each { |action|
        @path_by_action[action] = self.admin_path(:action => action) unless action == self.action_name || action =~ /gateway/
      }
    end

    def db_games_index
      @games = Game.all
    end

    def mochi_games_index
      @games = ::Aggregator.mochi.load().games.map(&:to_game)
    end

    def games_gateway

    end

  end
end