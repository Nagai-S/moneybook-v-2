# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.first

# user.confirm

user.genres.create(
  [
    { name: '食費', iae: false },
    { name: '給料', iae: true },
    { name: '交通費', iae: false },
    { name: '日用品', iae: false },
    { name: '娯楽', iae: false },
    { name: 'プレゼント', iae: false },
    { name: '不明', iae: false },
    { name: 'fashion', iae: false },
    { name: '医療', iae: false },
    { name: '学問', iae: false },
    { name: 'お小遣い', iae: true },
    { name: 'ボーナス', iae: true },
    { name: '利子', iae: true },
    { id: 18, name: '売上金', iae: true },
    { id: 20, name: '立替金返金', iae: true },
    { id: 21, name: '本', iae: false },
    { id: 30, name: '通信費', iae: false },
    { id: 31, name: '交際費', iae: false },
  ]
)

user.accounts.create(
  [
    { id: 13, name: '楽天銀行', value: 0 },
    # { id: 2, name: '京都中央信用金庫', value: 48_887 },
    # { id: 4, name: 'ゆうちょ', value: 278_080 },
    { id: 5, name: '現金', value: 54_835 },
    { id: 6, name: 'PayPay', value: 216 },
    { id: 12, name: 'メルペイ', value: 0 },
    { id: 16, name: '楽天Pay', value: 0 },
    { id: 18, name: 'スタバカード', value: 0 },
  ]
)

user.cards.create(
  [
    { name: 'YahooCard', account_id: 13, pay_date: 27, month_date: 31 },
    { name: 'RakutenCardJCB', account_id: 13, pay_date: 27, month_date: 31 },
    { id: 9, name: 'RakutenCardVISA', account_id: 13, pay_date: 27, month_date: 31 },
    {
      id: 7,
      name: 'メルペイMasterCard',
      account_id: 12,
      pay_date: 1,
      month_date: 31
    }
  ]
)

# if File.exist?(Rails.root+'effective_all_funds.txt')
#   file = File.open(Rails.root+'effective_all_funds.txt')
#   funds_array = file.readlines
#   data_length = funds_array.length/3
#   (data_length).times do |i|
#     j = i*3
#     str_id = funds_array[j+2]
#     value = funds_array[j+1]
#     name = funds_array[j]
#     name1 = NKF.nkf('-w -Z4', name)
#     name2 = NKF.nkf('-w -X', name1)
#     Fund.create(
#       name: name2.delete("\n"),
#       string_id: str_id.delete("\n"),
#       value: value.delete("\n")
#     )
#   end
# end
