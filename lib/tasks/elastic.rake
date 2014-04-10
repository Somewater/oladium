namespace :elastic do
  desc "Update games index"
  task :update_games => :environment do
    ENV['CLASS'] = 'Game'
    ENV['INDEX'] = index = "games_#{Time.new.strftime('%Y%m%d%H%M')}"
    Rake::Task["tire:import"].invoke
    `curl -XPOST http://127.0.0.1:9200/_aliases -d '{"actions":[{"add":{"alias":"games","index":"#{index}"}}]}'`
  end
end