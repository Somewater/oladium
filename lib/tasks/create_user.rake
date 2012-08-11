namespace :devise do

  desc 'creating a default user'
  task :create_user => ['environment'] do
    user = User.create! do |u|
      u.email = 'mktsz@mail.ru'
      u.password = 'adelaida'
      u.password_confirmation = 'adelaida'
    end
    puts 'New user created!'
    puts 'Email : ' << user.email
    puts 'Password: ' << user.password
  end
end