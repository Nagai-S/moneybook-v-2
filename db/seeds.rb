# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user=User.first

user.confirm

user.genres.create(
  [
    {name: "食費", iae: false},
    {name: "給料", iae: true},
    {name: "交通費", iae: false},
    {name: "日用品", iae: false},
    {name: "娯楽", iae: false},
    {name: "プレゼント", iae: false},
    {name: "不明", iae: false},
    {name: "fashion", iae: false},
    {name: "医療", iae: false},
    {name: "学問", iae: false},
    {name: "お小遣い", iae: true},
    {name: "ボーナス", iae: true},
    {name: "利子", iae: true},
    {name: "売上金", iae: false},
    {name: "立替金返金", iae: false},
  ]
)

user.accounts.create(
  [
    {name: "楽天銀行", value: 0},
    {name: "京都中央信用金庫", value: 48887},
    {name: "メルペイ", value: "0"},
    {name: "ゆうちょ", value: 278080},
    {name: "現金", value: 54835},
    {name: "PayPay", value: 216},
    {name: "SoftBankCard", value: 111},
    {name: "eMAXIS S&P500", value: 0},
    {name: "楽天全米index fund", value: 0},
  ]
)

user.cards.create(
  [
    {name: "YahooCard", account_id: 4, pay_date: 27, month_date: 31},
    {name: "RakutenCard", account_id: 4, pay_date: 27, month_date: 31},
    {name: "メルペイMasterCard", account_id: 3, pay_date: 1, month_date: 31},
  ]
)