# == Schema Information
#
# Table name: fund_users
#
#  id                :bigint           not null, primary key
#  average_buy_value :decimal(10, 2)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  fund_id           :bigint           not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_fund_users_on_fund_id  (fund_id)
#  index_fund_users_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (fund_id => funds.id)
#  fk_rails_...  (user_id => users.id)
#
class FundUser < ApplicationRecord
  belongs_to :user
  belongs_to :fund
  has_many :fund_user_histories, dependent: :delete_all

  validates(
    :average_buy_value,
    presence: {
      message: 'は必要項目です'
    },
    numericality: {
      only_float: {
        message: 'は数字を入力してください'
      }
    }
  )

  def total_buy_value
    return fund_user_histories.where(buy_or_sell: true).sum(:value)
  end

  def total_sell_value
    return fund_user_histories.where(buy_or_sell: false).sum(:value)
  end

  def now_value
    return_value =
      if fund.value
        (
          (
            (total_buy_value - total_buy_commission).to_f * 
            fund.value.to_f / average_buy_value.to_f
          ) - total_sell_value
        ).round
      else
        (
          total_buy_value.to_f - total_buy_commission.to_f -
            total_sell_value.to_f
        ).round
      end

    return return_value
  end

  def total_buy_commission
    return fund_user_histories.where(buy_or_sell: true).sum(:commission)
  end

  def gain_value
    return now_value - total_buy_value
  end
end
