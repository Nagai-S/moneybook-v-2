docker-compose build
echo "complete build"
docker-compose run --rm rails yarn install
echo "complete yarn install"
docker-compose down
docker-compose up -d
echo "complete app start"
docker-compose run --rm rails bundle exec rails db:create
echo "complete db:create"
docker-compose run --rm rails bundle exec rails db:migrate
echo "complete db:migrate"
ruby api_request_scripts/sign_up.rb
echo "complete create user"
docker-compose run --rm rails bundle exec rake db:seed
echo "complete rake db:seed"
if [ -e ".env" ]; then
  echo ".env exists"
  ruby api_request_scripts/data_registration.rb
  docker-compose run --rm rails bundle exec rake modify_db:modif_event
  echo "complete all events database from production"
fi
