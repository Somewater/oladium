# encoding: utf-8

require 'fileutils'

class GameDownloader
  include Sidekiq::Worker

  sidekiq_options :retry => 3

  def perform(url, game_id)
    process(url, game_id)
  rescue NotPerform => error
    logger.error("Error #{error} on #{error.backtrace.join("\n")}")
  end

  def process(url, game_id)
    game = Game.find game_id
    local_path = game.local_path
    tmp_file_path = "#{File.dirname(local_path)}/diff_#{rand(1000000)}#{File.extname(local_path)}"
    `wget --quiet "#{url}" -O "#{tmp_file_path}"`

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
    files = get_zip_filenames(zip_filepath)
    selected_file = files.select{|f| File.extname(f) == extname }
    raise NotPerform, "File *#{extname} not found in archive, found: #{files.join(', ')}" if selected_file.empty?
    raise NotPerform, "Double files in archive #{selected_file.join(', ')}" if selected_file.size > 1

    zip_root = File.dirname zip_filepath
    extract_dir = "#{zip_root}/extract_#{rand(1000000)}"
    `unzip "#{zip_filepath}" -d "#{extract_dir}"`
    new_filepath = File.join(zip_root, File.basename(selected_file.first))
    FileUtils.mv File.join(extract_dir, selected_file.first), new_filepath
    File.unlink zip_filepath
    FileUtils.rmtree(extract_dir, :force => true)
    new_filepath
  end

  def get_zip_filenames(zip_filepath)
    res = `unzip -l "#{zip_filepath}"`
    res.scan(/\d+\s+[\d\-]+\s+[\d\:]+\s+(?<file>.+)/).map{|a| a.first}
  end

  class NotPerform < RuntimeError
  end
end
