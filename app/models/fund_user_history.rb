# == Schema Information
#
# Table name: fund_user_histories
#
#  id           :bigint           not null, primary key
#  buy_or_sell  :boolean          default(TRUE)
#  commission   :integer
#  date         :date
#  pay_date     :date
#  pon          :boolean          default(FALSE)
#  value        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :bigint
#  card_id      :bigint
#  fund_user_id :bigint           not null
#
# Indexes
#
#  index_fund_user_histories_on_account_id    (account_id)
#  index_fund_user_histories_on_card_id       (card_id)
#  index_fund_user_histories_on_fund_user_id  (fund_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (fund_user_id => fund_users.id)
#
class FundUserHistory < ApplicationRecord
  include MyFunction::FunctionForChange

  belongs_to :account, optional: true
  belongs_to :card, optional: true
  belongs_to :fund_user

  default_scope -> { order(date: :desc) }

  validates :date, presence: true
  validates :value,
            presence: {
              message: 'は一桁以上入力してください。'
            },
            numericality: {
              message: 'は半角数字で入力してください。',
              only_integer: {
                message: 'は整数で入力してください。'
              }
            }
  validates :commission,
            presence: {
              message: 'は一桁以上入力してください。'
            },
            numericality: {
              message: 'は半角数字で入力してください。',
              only_integer: {
                message: 'は整数で入力してください。'
              }
            }

  def buy_or_sell_name
    return buy_or_sell ? '購入' : '売却'
  end

  def payment_source_name
    if card
      card.name
    elsif account
      account.name
    else
      'ー'
    end
  end

  def update_account(account_id)
    update(account_id: account_id)
  end
end
