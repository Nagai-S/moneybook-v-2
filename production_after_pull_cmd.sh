git pull origin master
sudo kill -9 $(ps aux | grep 'unicorn_rails master' | grep -v grep | awk '{print $2}')
bundle install
bundle exec rails db:migrate
bundle exec rake assets:precompile
bundle exec whenever --clear-crontab
bundle exec whenever --update-crontab
RAILS_SERVE_STATIC_FILES=1 bundle exec unicorn_rails -c config/unicorn.rb -E production -D