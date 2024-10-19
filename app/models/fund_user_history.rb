# == Schema Information
#
# Table name: fund_user_histories
#
#  id           :bigint           not null, primary key
#  buy_date     :date
#  buy_or_sell  :boolean          default(TRUE)
#  commission   :decimal(10, 2)   default(0.0)
#  date         :date
#  pay_date     :date
#  value        :decimal(10, 2)
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
  include ApplicationHelper

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
            }
  validates :commission,
            presence: {
              message: 'は一桁以上入力してください。'
            },
            numericality: {
              message: 'は半角数字で入力してください。',
            }
            
  validate :same_user

  after_save do 
    update_columns(buy_date: nil) unless buy_or_sell
    after_change_action
  end

  def bought?
    if buy_or_sell && buy_date
      buy_date <= today(user)
    else
      true
    end
  end

  def user
    fund_user.user
  end
            
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

  private

  def same_user
    user_ids = [fund_user.user_id]
    account && user_ids << account.user_id
    card && user_ids << card.user_id

    if user_ids.uniq.size != 1
      errors.add(:user_id, ' different')
    end
  end
end
