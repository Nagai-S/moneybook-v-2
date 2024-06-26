# Assets Management Application

## How to build development environment
before building -> Install [Docker](https://hub.docker.com/editions/community/docker-ce-desktop-mac).

1. Run the following command to clone the code from this repository.
```
$ git clone https://github.com/Nagai-S/moneybook-v-2.git
```
2. In terminal, change directory to cloned repository.
3. Run the following command.
```
$ bash initial.sh
```
4. Visit http://localhost:8080
5. Login with email: a@gmail.com, password: asdfghjkl


### How to access database
```
$ mysql -u root -ppassword -h localhost -P 3306 --protocol=tcp
```

### How to go into docker container shell
```
$ docker-compose run --rm rails bash
```

### Stop docker container
```
$ docker-compose down
```

### Restart docker container
```
$ docker-compose up
```

### How to create .env
```
$ cp env_file_model.txt .env
```
and write necessary variables on .env.

##  How to test
```
$ docker-compose run --rm rails bundle exec rspec
$ docker-compose run --rm rails bundle exec rspec spec/system/user_flow.rb
```

## Main Function
### Account management
* You can manage your balance related to each account (cash, bank, ...).
* You can transfer the balance from an account to another as well as from a card to an account.

### History management regarding your expence and income
* You can register histories about your expence and income with used accounts or cards, related genres, and short note.
* You can look up the histories in a various ways.

### Card Management
You can register cards which have the following information
1. Closing date
2. Withdrawal date
3. Linked account

You can figure out the balance of the account linked to the card at the current and after withdrawal.

Passing the withdrawal date, the balance of the account linked to the card can be updated automatically.

### Investment Funds
* You can register investment funds in Japan.
* The market value of investment funds can be updated daily and, you can manage your entire assets including investment funds. 

### Pie Chart
The following value is displayed as pie charts.
* The balance of each account and investment funds.
* The amount of your expence and income related to each genre within a current month.

### With iPhone
* You can eacily register your financial histories by using Short Cut Application of iOS.

## Outlook
* To register periodic event
* To register stocks, bonds and commodities in addition to investment funds

## About API
1. Sign up on the web page
2. POST /api/v1/auth/sign_in with body:{email: "your-email", password: "your-password"}
3. Write down [access-token, client, uid] in response.header
4. Next time to access with API, send requests with headers [access-token, client, uid].

## Production Environment
https://assetsmanagement.xyz

