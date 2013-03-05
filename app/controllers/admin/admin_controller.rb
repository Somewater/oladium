module Admin
  class AdminController < ApplicationController
    before_filter :authenticate_user!
    before_filter :set_en_locale
    layout 'admin_area'
    include ApplicationHelper

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
      #@games = ::Aggregator.mochi.load().games.map(&:to_game)
    end

    def games_gateway
      params[:net] = 'mochi' unless params[:net]

      @total = 0
      @offset = 0
      @query = ''
      if(params[:net] == 'db')
        @games = Game.all
      else
        aggregator = ::Aggregator.send(params[:net].to_sym)
        aggregator.load(params)
        @games = aggregator.games.map &:to_game
        @total = aggregator.total
        @offset = aggregator.offset
        @query = aggregator.query
      end

      @games.map! do |game|
        h = game_to_hash(game)
        h['new_record'] = !Game.exists?(:net => h[:net], :net_id => h[:net_id])
        h
      end

      render :text => {:total => (@total > 0 ? @total : @games.size),
                       :offset => @offset, :games => @games, :query => @query}.to_json
    end

    def controller_gateway
      case params[:task]
        when 'delete'
          g = Game.find_by_net_and_net_id(params[:net], params[:net_id])
          raise "Can't find game by net #{params[:net]} net_id #{params[:net_id]}" unless g
          g.destroy
          render :text => 'ok'
        when 'add'
          game = JSON.parse(params[:game])
          category = game['category']
          remove_protected_params(game)
          g = Game.new()
          g.category = Category.send(category)
          g.update_attributes(game)
          g.save!
          render :text => game_to_hash(g).to_json
        else
          raise "Undefined task"
      end
    end

    private
    def remove_protected_params(params)
      params.delete('new_record')
      params.delete('category')
      params.delete('path')
    end

    def set_en_locale
      I18n.locale = :en
    end

  end
end