# お小遣いアプリ

## 環境構築
### 前提
Dockerを[インストール](https://hub.docker.com/editions/community/docker-ce-desktop-mac)しておく

### 手順
1. このリポジトリをローカルにclone
2. terminalでこのリポジトリのあるディレクトリまで移動
3. 以下のコマンドを実行
```
$ bash initial.sh
```
4. http://localhost:8080
にアクセス
5. email: a@gmail.com, password: asdfghjkl でログインする


### データベースにアクセスするには
```
$ mysql -u root -p -h localhost -P 3306 --protocol=tcp
```

パスワードを要求されるのでpasswordと入力

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

### .envファイルを作成するとき
```
$ cp env_file_model.txt .env
```
で.envに必要な変数を入れていく



## 主な機能
* アカウントを分けれる機能（銀行、現金、paypayなど）
* ジャンルで登録できる機能
* イベントごとにメモを残せる機能
* 締め日、引き落とし日、連携アカウントを登録したクレジットカードを登録することで、記録する際にクレジットカードを選べるようになり、現在残高と、クレジットカード分引き落とし後の残高を両方確認できる機能
* アカウント間の振り替え機能（クレジットカードから別のアカウントへの振替も可能）
* 検索機能（イベントについて、さまざまな方法での検索を可能にした）
* 投資信託を登録できるようにして、その値を日々更新すると共に資産全体を管理できる機能
* 円グラフで資産の割合や投資信託の割合などをみやすく管理できる機能

## 追加予定の機能
* iPhoneのショートカットから記録できるようにするショートカットの作成
* 周期的な記録を設定しておける機能

## APIについて
1. sign up on web page
2. POST /api/v1/auth/sign_in with body:{email: "your-email", password: "your-password"}
3. regist [access-token, client, uid] in response.header

apiの情報については今後./doc/内に載せていく予定。

## 実際のサイト
https://moneybook-moneybook.herokuapp.com
に公開しています。
