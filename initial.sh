docker-compose build
echo "complete build-------------------------------------------------------------"

docker-compose run --rm rails yarn install
echo "complete yarn install------------------------------------------------------"

docker-compose down
docker-compose up -d
echo "complete app start---------------------------------------------------------"

docker-compose run --rm rails bundle exec rake db:create db:migrate
echo "complete db create---------------------------------------------------------"

ruby api_request_scripts/sign_up.rb
echo "complete create user-------------------------------------------------------"

docker-compose run --rm rails bundle exec rake db:seed
echo "complete rake db:seed------------------------------------------------------"

if [ -e ".env" ]; then
  echo ".env exists--------------------------------------------------------------"
  ruby api_request_scripts/data_registration.rb
  docker-compose run --rm rails bundle exec rake daily_change:update_fund_value
  echo "complete migration of all data from production-----------------------"
fi

echo "finish!!!------------------------------------------------------------------"