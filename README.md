# お小遣いアプリ

## 環境構築
### 前提
Dockerを[インストール](https://hub.docker.com/editions/community/docker-ce-desktop-mac)しておく

### 手順
1. このリポジトリをローカルにclone
2. terminalでこのリポジトリのあるディレクトリまで移動
3. 以下のコマンドを上から順に実行
```
$ docker-compose build
$ docker-compose run --rm rails yarn install
$ docker-compose down
$ docker-compose up
$ docker-compose run --rm rails bundle exec rails db:create
$ docker-compose run --rm rails bundle exec rails db:migrate
```
4. http://localhost:3000
にアクセス

### データベースにアクセスするには
```
$ mysql -u root -p -h localhost -P 3306 --protocol=tcp
```

### dockerのshellに入るには
```
$ docker-compose run --rm rails bash
```

### dockerを停止
```
$ docker-compose down
```

### dockerを起動（二回目以降）
```
$ docker-compose up
```



## 主な機能
* アカウントを分けれる機能（銀行、現金、paypayなど）
* ジャンルで登録できる機能
* イベントごとにメモを残せる機能
* 締め日、引き落とし日、連携アカウントを登録したクレジットカードを登録することで、記録する際にクレジットカードを選べるようになり、現在残高と、クレジットカード分引き落とし後の残高を両方確認できる機能
* アカウント間の振り替え機能（クレジットカードから別のアカウントへの振替も可能）
* 検索機能（イベントについて、さまざまな方法での検索を可能にした）

## 追加予定の機能
* iPhoneのショートカットから記録できるようにするショートカットの作成
* 投資信託を登録できるようにして、その値を日々更新すると共に資産全体を管理できるようになる。
* 周期的な記録を設定しておける機能

## APIについて
* webから会員登録して、POST /api/v1/auth/sign_inでbodyとして{email: "youremail", password: "yourpassword"}でリクエストを送って返ってきた
headerのうち"accesstoken"と"client"と"uid"をheaderに載せてリクエストを送信することで、apiとして扱える。apiの情報については今後./doc/内に載せていく予定。

## 実際のサイト
https://moneybook-moneybook.herokuapp.com
に公開しています。
