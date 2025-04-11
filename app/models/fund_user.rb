# == Schema Information
#
# Table name: fund_users
#
#  id                 :bigint           not null, primary key
#  average_buy_value  :decimal(10, 2)
#  average_sell_value :decimal(10, 2)   default(0.0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  currency_id        :bigint           not null
#  fund_id            :bigint           not null
#  user_id            :bigint           not null
#
# Indexes
#
#  index_fund_users_on_currency_id  (currency_id)
#  index_fund_users_on_fund_id      (fund_id)
#  index_fund_users_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (fund_id => funds.id)
#  fk_rails_...  (user_id => users.id)
#
class FundUser < ApplicationRecord
  include ApplicationHelper

  belongs_to :user
  belongs_to :fund
  belongs_to :currency
  has_many :fund_user_histories, dependent: :delete_all

  validates(
    :average_buy_value,
    presence: {
      message: 'は必要項目です'
    },
    numericality: {
      only_float: {
        message: 'は数字を入力してください'
      },
      greater_than: 0
    }
  )

  def after_save_action(total_buy_value)
    if total_buy_value.to_i != 0
      fund_user_histories.create(
        value: total_buy_value,        
        date: Time.current.to_date,
        buy_date: Time.current.to_date,
        commission: 0,
        buy_or_sell: true,        
      )
    end
    fund.set_now_value_of_fund if fund.update_on != Time.current.to_date
  end

  def scale_factor
    return currency_id == user.currency_id ? 1 : self.currency.scale_to(user.currency)
  end

  def total_buy_value(arg={scale: false})
    total_value = fund_user_histories.where(buy_or_sell: true).select(&:bought?).sum(&:value)
    return arg[:scale] ? total_value * scale_factor : total_value
  end

  def total_sell_value(arg={scale: false})
    total_value = fund_user_histories.where(buy_or_sell: false).sum(&:value)
    return arg[:scale] ? total_value * scale_factor : total_value
  end

  def now_value(arg={scale: false})
    if fund_user_histories.exists?(buy_or_sell: false)
      total_value = fund.value ? (
        ((total_buy_value / average_buy_value + total_sell_value / average_sell_value) * fund.value).round
      ) : (
        (total_buy_value + total_sell_value).round
      )
    else
      total_value = fund.value ? (
        ((total_buy_value / average_buy_value) * fund.value).round
      ) : (
        (total_buy_value).round
      )
    end

    return arg[:scale] ? total_value * scale_factor : total_value
  end

  def gain_value(arg={scale: false})
    return now_value({scale: arg[:scale]}) - (total_buy_value({scale: arg[:scale]}) + total_sell_value({scale: arg[:scale]}))
  end
end
