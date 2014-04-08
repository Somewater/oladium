# encoding: utf-8

require 'fileutils'

class FileDiffDownloader
  include Sidekiq::Worker

  sidekiq_options :retry => 3

  def perform(url, local_path, new_local_path = nil, options = {})
    tmp_file_path = "#{File.dirname(local_path)}/diff_#{rand(1000000)}#{File.extname(local_path)}"
    `wget "#{url}" -O "#{tmp_file_path}"`
    if File.exist?(local_path) && `cmp "#{local_path}" "#{tmp_file_path}"`.empty?
      File.unlink tmp_file_path
    else
      unless new_local_path.present?
        new_local_path = GameUtils.filepath_to_next_version_filename local_path
      end
      FileUtils.mv tmp_file_path, new_local_path, :force => true
      if game_id
        game = Game.find game_id
        game.update_attribute :body, new_local_path
      end
    end
  end
end
