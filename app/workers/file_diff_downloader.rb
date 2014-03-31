# encoding: utf-8

require 'fileutils'

class FileDiffDownloader
  include Sidekiq::Worker

  sidekiq_options :retry => 3

  def perform(url, local_path, game_id = nil)
    tmp_file_path = "#{File.dirname(local_path)}/diff_#{rand(1000000)}#{File.extname(local_path)}"
    `wget "#{url}" -O "#{tmp_file_path}"`
    if File.exist?(local_path) && `cmp "#{local_path}" "#{tmp_file_path}"`.empty?
      File.unlink tmp_file_path
    else
      if game_id
        game = Game.find(game_id)
        local_path = File.join File.dirname(local_path), 'main2.swf'
        game.update_column :body, File.join(File.dirname(game.body), 'main2.swf')
      end
      FileUtils.mv tmp_file_path, local_path, :force => true
    end
  end
end
