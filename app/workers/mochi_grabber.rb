# encoding: utf-8

class MochiGrabber
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def perform(count = 100, limit = 100)
    status_setting = Setting.find_or_create_by_key('mochi_grabber.status')
    if status_setting.value.present? && status_setting.value != 'sleep'
      logger.error("Status already '#{status_setting.value}'")
      return
    end
    status_setting.update_column :value, 'working'

    offset_setting = Setting.find_or_create_by_key('mochi_grabber.offset')
    count_setting = Setting.find_or_create_by_key('mochi_grabber.count')
    offset = offset_setting.value.to_i

    loaded_count = 0
    while(loaded_count < count)
      mochi = Aggregator.mochi
      params = {:limit => limit, :offset => offset}
      mochi.load(params)
      saved_games = 0
      mochi.games.each do |g|
        if g.net_data['recommended']
          if save_game(g, offset)
            saved_games += 1
            count_setting.update_column :value, (count_setting.value.to_i + 1).to_s
          end
        end
      end

      if mochi.games.empty? && mochi.total.to_i <= offset
        status_setting.update_column :value, 'completed'
        return
      end

      loaded_count += mochi.games.size
      offset += mochi.games.size
      offset_setting.update_column :value, offset
      logger.info "Loaded #{mochi.games.size} games, saved #{saved_games} games, offset #{offset}"
    end

    status_setting.update_column :value, 'sleep'
  rescue
    logger.error "#{$!}\n#{$!.backtrace.join("\n")}"
    status_setting.update_column :value, $!.to_s if status_setting
  end

  def save_game(g, offset)
    return false if Game.exists?(:net_id => g.net_id, :net => Aggregator::MochiAggregator::NET)

    folder_path = "#{(offset.to_i / 1000) * 1000}/#{g.slug}"
    game = g.to_game
    game.type = Game::TYPE_SWF_FILE
    game.image = "#{folder_path}/thumb#{ File.extname g.image }"
    game.body = "#{folder_path}/main.swf"
    game.save

    base_path = "#{Rails.public_path}/games"
    FileUtils.mkdir_p "#{base_path}/#{folder_path}"
    FileDownloader.perform_async g.image, "#{base_path}/#{game.image}"
    FileDownloader.perform_async g.body, "#{base_path}/#{game.body}"

    true
  end
end