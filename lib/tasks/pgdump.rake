namespace :pgdump do
  task :save do
    require 'fileutils'
    require 'yaml'
    FileUtils.mkdir_p tmp_folder
    dump_name = File.join tmp_folder, "dump_#{Time.new.strftime('%Y%m%d_%H%M')}.sql"
    FileUtils.chdir Rails.root
    cmd "pg_dump -F c -U #{database_conf["username"]} -h localhost -f \"#{dump_name}\" #{database_conf["database"]}"
    puts "Dump #{File.basename(dump_name)} created"
  end

  task :load do
    require 'fileutils'
    FileUtils.mkdir_p tmp_folder
    variants = Dir["#{tmp_folder}/*.sql"].each.to_a.sort
    puts "Select version"
    variants.each_with_index{|f,i| puts "#{i}> #{f}" }
    idx = STDIN.gets.chomp.to_i
    variant = variants[idx]
    puts "Loading #{variant} dump"
    cmd "dropdb -U #{database_conf["username"]} #{database_conf["database"]}"
    cmd "createdb -U #{database_conf["username"]} -O #{database_conf["username"]} #{database_conf["database"]}"
    cmd "pg_restore -d #{database_conf["database"]} -c -C -F c -U #{database_conf["username"]} \"#{variant}\""
  end

  task :sync do
    require 'fileutils'
    FileUtils.mkdir_p tmp_folder
    cmd "rsync -a --ignore-existing pav@atlantor.ru:oladium/tmp/pgdump/*.sql tmp/pgdump"
  end

  def tmp_folder
    @tmp_folder ||= File.join(Rails.root, 'tmp', 'pgdump')
  end

  def database_conf(env = nil)
    @database_conf ||= YAML.load(File.open(File.join(Rails.root, 'config', 'database.yml')).read)
    @database_conf[env || Rails.env]
  end

  def cmd line
    puts "> #{line}"
    IO.popen(line) { |f| puts f.read }
  end
end