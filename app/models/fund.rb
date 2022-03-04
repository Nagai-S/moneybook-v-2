# == Schema Information
#
# Table name: funds
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  update_on  :date
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  string_id  :string(255)
#
require 'open-uri'
require 'nokogiri'

class Fund < ApplicationRecord
  has_many :fund_users, dependent: :destroy
  has_many :users, through: :fund_users

  validates :name, presence: { message: 'は１文字以上入力してください。' }

  def set_now_value_of_fund
    id = string_id
    url =
      'https://www.rakuten-sec.co.jp/web/fund/rakuten-bank/detail.html?ID=' + id
    charset = nil
    html =
      URI.open(url) do |page|
        charset = page.charset
        page.read
      end

    contents = Nokogiri::HTML.parse(html, nil, charset)
    value_str = contents.xpath('//span[@class="value-01"]').inner_text
    value = value_str.gsub(',', '')

    update(value: value, update_on: Date.today)
  end
end
