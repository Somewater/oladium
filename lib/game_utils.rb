# encoding: utf-8

module GameUtils
  def version
    filename = File.basename(self)
    ext = File.extname(filename)
    filename_without_ext = filename[0...-(ext.size)]
    m = /\d+$/.match(filename_without_ext)
    version = m ? m[0].to_i : 1
    new_local_path = File.dirname(filename)
  end

  def self.filepath_to_version(filepath)
    filename = File.basename(filepath)
    ext = File.extname(filename)
    filename_without_ext = filename[0...-(ext.size)]
    m = /^(?<name>.*[^\d]+)(?<version>\d+)?$/.match(filename_without_ext)
    version = m[:version] ? m[:version].to_i : 1
    version
  end

  def self.filepath_to_next_version_filename(filepath, custom_ext = nil)
    filename = File.basename(filepath)
    ext = File.extname(filename)
    filename_without_ext = filename[0...-(ext.size)]
    m = /^(?<name>.*[^\d]+)(?<version>\d+)?$/.match(filename_without_ext)
    version = m[:version] ? m[:version].to_i : 1
    version += 1
    "#{m[:name]}#{version}#{custom_ext || ext}"
  end
end
