module ApplicationHelper
  def game_path(game)
    super(game.id ? game.id : "net-#{game.net}-id-#{game.net_id}")
  end
end
