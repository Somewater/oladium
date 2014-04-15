# encoding: utf-8

module GameCache
  extend self

  def fetch(scope, hash, page, per_page = nil)
    @game_ids_cache ||= {}
    per_page ||= GamesController::GAMES_PER_PAGE

    ids_all = fetch_from(@game_ids_cache, hash){ scope.pluck(:id) }
    count = ids_all.size
    ids = ids_all[(page * per_page)...((page + 1) * per_page)]

    collection = GamesCollection.new(Game.find(ids))
    collection.count = count
    collection
  end

  class GamesCollection < Array
    attr_accessor :count
  end

  private
  def fetch_from(cache, key, &block)
    unless cache[key] && (cache[key][:created] + 5.minutes > Time.new)
      cache[key] = begin
        data = block.call
        {:data => data, :created => Time.new}
      end
    end
    cache[key][:data]
  end
end