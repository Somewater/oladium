# encoding: utf-8

class MochiGrabber
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def perform(count = 1000, limit = 100)
    status_setting = Setting.find_or_create_by_key('mochi_grabber.status')
    if status_setting.value == 'working' || status_setting.value.to_s[0..4] == 'stop:'
      logger.error("Status already '#{status_setting.value}'")
      return
    end
    status_setting.update_column :value, 'working'

    offset_setting = Setting.find_or_create_by_key('mochi_grabber.offset')
    count_setting = Setting.find_or_create_by_key('mochi_grabber.count')
    offset = offset_setting.value.to_i

    loaded_count = 0
    c = 0
    while(loaded_count < count)
      mochi = Aggregator.mochi
      params = {:limit => limit, :offset => offset}
      load_try_count = 0
      begin
        mochi.load(params)
      rescue Timeout::Error
        load_try_count += 1
        if load_try_count < 10
          retry
        else
          throw $!
        end
      end
      saved_games = 0
      mochi.games.each do |g|
        if !g.net_data['recommended'] && g.net_data['popularity'].to_i >= 100
          if save_game(g, offset)
            saved_games += 1
            count_setting.update_column :value, (count_setting.value.to_i + 1).to_s
          end
        end
      end

      if mochi.games.empty? && mochi.total.to_i <= offset
        status_setting.update_column :value, 'stop:completed'
        return
      end

      c += 1
      if c > 100
        status_setting.update_column :value, 'stop:cycle'
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
    status_setting.update_column :value, $!.to_s.truncate(200) if status_setting
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
