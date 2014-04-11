namespace :elastic do
  desc "Update games index"
  task :update_games => :environment do
    ENV['CLASS'] = 'Game'
    ENV['INDEX'] = index = "games_#{Time.new.strftime('%Y%m%d%H%M')}"
    Rake::Task["tire:import"].invoke
    action = {actions: [{add: {alias: :games, index: index}}]}
    puts `curl -XDELETE http://localhost:9200/games`
    sleep 5
    puts `curl -XPOST http://127.0.0.1:9200/_aliases -d "#{ action.to_json.gsub('"', '\\"') }"`
  end
end