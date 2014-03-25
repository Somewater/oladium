module ApplicationHelper
  def game_path(game)
    super(game.respond_to?(:to_param) ? game.to_param : "net-#{game.net}-id-#{game.net_id}?q=" + (game.game_model ? game.game_model.query : ''))
  end

  def url_for_params(params)
    url_for(self.params.merge(params))
  end

  def each_with_borders(array, &block)
    last_index = array.size - 1
    index = 0
    array.each do |item|
      block.call(item, index, index == last_index)
      index += 1
    end
  end

  def paginate_collection(collection, current, page_half_quantity, &block)
    length = collection.length
    index = collection.index(current)
    start_index = [index - page_half_quantity, 0].max
    end_index = [index + page_half_quantity, length].min
    each_with_borders(collection[start_index...end_index]) do |item, idx, last|
      item_index = start_index + idx
      block.call(item, item_index, idx == 0 && item_index > 0, last && item_index < length - 1)
    end
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
