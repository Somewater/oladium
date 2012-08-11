module ApplicationHelper
  def game_path(game)
    super(game.id ? game.id : "net-#{game.net}-id-#{game.net_id}")
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
