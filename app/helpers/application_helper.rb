module ApplicationHelper
  def game_path(game)
    super(game.respond_to?(:to_param) ? game.to_param : "net-#{game.net}-id-#{game.net_id}?q=" + (game.game_model ? game.game_model.query : ''))
  end

  def url_for_params(params)
    url_for(self.params.merge(params))
  end

  private
  def game_to_hash(game)
    h = { :net => game.net, :net_id => game.net_id, :title => game.title, :description => game.description,
          :body => game.body, :type => game.type, :width => game.width, :height => game.height,
          :image => game.image, :tags => game.tags, :driving => game.driving
        }
    h[:category] = game.category.name if game.category
    h[:path] = game_path(game)
    h[:new_record] = game.new_record?
    h
  end
end
