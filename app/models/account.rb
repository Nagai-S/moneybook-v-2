# == Schema Information
#
# Table name: accounts
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Account < ApplicationRecord
  belongs_to :user
  has_many :cards
  has_many :events
  has_many :shortcuts, dependent: :destroy
  has_many :fund_user_histories
  has_many :account_exchanges_to,
           class_name: 'AccountExchange',
           foreign_key: :to_id
  has_many :account_exchanges_source,
           class_name: 'AccountExchange',
           foreign_key: :source_id

  validates :name,
            presence: {
              message: 'は１文字以上入力してください。'
            },
            uniqueness: {
              scope: :user,
              message: '「%{value}」と同じ名前のアカウントが存在します。',
              case_sensitive: false
            }
  validates :value,
            presence: {
              message: 'は１桁以上入力してください。'
            },
            numericality: {
              message: 'は半角数字で入力してください。',
              only_integer: {
                message: 'は整数で入力してください。'
              }
            }
  
  before_destroy do
    if cards.exists?
      throw :abort
    else
      before_destroy_action
    end
  end

  def before_destroy_action
    events.each { |event| event.update(account_id: nil) }
    account_exchanges_to.each { |ax| ax.update(to_id: nil) }
    account_exchanges_source.each { |ax| ax.update(source_id: nil) }
    fund_user_histories.each do |fund_user_history|
      fund_user_history.update(account_id: nil)
    end
  end

  def after_pay_value
    event_in_sum = events.where(iae: true).sum(&:value)
    event_ex_sum = events.where(iae: false).sum(&:value)
    ax_source_sum = account_exchanges_source.sum(&:value)
    ax_to_sum = account_exchanges_to.sum(&:value)
    fund_user_history_buy_sum =
      fund_user_histories.where(buy_or_sell: true).sum(&:value)
    fund_user_history_sell_sum =
      fund_user_histories.where(buy_or_sell: false).sum(&:value)
    fund_user_history_sell_commission_sum =
      fund_user_histories.where(buy_or_sell: false).sum(:commission)

    return [
      value,
      event_in_sum,
      event_ex_sum * (-1),
      ax_to_sum,
      ax_source_sum * (-1),
      fund_user_history_sell_sum,
      fund_user_history_buy_sum * (-1),
      fund_user_history_sell_commission_sum * (-1),
    ].sum
  end

  def now_value
    event_in_sum = events.where(iae: true).select(&:payed?).sum(&:value)
    event_ex_sum = events.where(iae: false).select(&:payed?).sum(&:value)
    ax_source_sum = account_exchanges_source.select(&:payed?).sum(&:value)
    ax_to_sum = account_exchanges_to.sum(&:value)
    fund_user_history_buy_sum =
      fund_user_histories.where(buy_or_sell: true).select(&:payed?).sum(&:value)
    fund_user_history_sell_sum =
      fund_user_histories.where(buy_or_sell: false).select(&:payed?).sum(&:value)
    fund_user_history_sell_commission_sum =
      fund_user_histories.where(buy_or_sell: false).select(&:payed?).sum(&:commission)

    return [
      value,
      event_in_sum,
      event_ex_sum * (-1),
      ax_to_sum,
      ax_source_sum * (-1),
      fund_user_history_sell_sum,
      fund_user_history_buy_sum * (-1),
      fund_user_history_sell_commission_sum * (-1),
    ].sum
  end
end
