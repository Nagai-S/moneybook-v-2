# Assets Management Application

## How to build development environment
before building -> Install [Docker](https://hub.docker.com/editions/community/docker-ce-desktop-mac).

1. Run a follow command.
```
$ git clone https://github.com/Nagai-S/moneybook-v-2.git
```
2. In terminal, change directory to cloned repository.
3. Run a follow command.
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
and write necessary valuables into .env.

## Main Function
### Account Management
* You can manage your balance for each account (cash, bank, ...).
* You can transfer between accounts (include from card to account).

### Storing using history
* You can register with an genre and note.
* You can search by any method.

### Card Management
You can register a card specifying
1. Closing date
2. Withdrawal date
3. Linked account

and you can register history with a card.
You can find out balance now and after withdrawal.

Passing withdrawal date, update balance automatically.

### Investment Funds
* You can register investment funds in Japan.
* Update market value of investment funds daily and, you can manage all assets include investment funds. 

### Pie Chart
Displayed as a pie chart following percentage.
* Percentage of each account and investment funds of assets
* Percentage of investment funds
* Percentage of each genre of expence and income this month.

### With iPhone
* Using ShortCutApplication of iOS, register using history easier.

## Outlook
* Register periodic event
* In addition to investment funds, to register stocks, bonds and commodities and you can manage all your assets.

## About API
1. Sign up on web page
2. POST /api/v1/auth/sign_in with body:{email: "your-email", password: "your-password"}
3. Write down [access-token, client, uid] in response.header
4. Next time to access with API, send requests with headers [access-token, client, uid].

## Production Environment
https://moneybook-moneybook.herokuapp.com

