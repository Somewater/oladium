# encoding: utf-8

require 'fileutils'

class GameDownloader
  include Sidekiq::Worker

  sidekiq_options :retry => 3

  def perform(url, game_id)
    game = Game.find game_id
    local_path = game.local_path
    tmp_file_path = "#{File.dirname(local_path)}/diff_#{rand(1000000)}#{File.extname(local_path)}"
    `wget "#{url}" -O "#{tmp_file_path}"`

    tmp_file_path = process_zip(tmp_file_path, File.extname(local_path)) if File.extname(url).downcase == '.zip'

    if File.exist?(local_path) && `cmp "#{local_path}" "#{tmp_file_path}"`.empty?
      File.unlink tmp_file_path
    else
      new_local_filename = GameUtils.filepath_to_next_version_filename local_path
      new_local_path = File.join(File.dirname(local_path), new_local_filename)
      FileUtils.mv tmp_file_path, new_local_path, :force => true
      game.local_path = new_local_path
      game.save
    end
  end

  def process_zip(zip_filepath, extname)

  end
end
