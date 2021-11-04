# == Schema Information
#
# Table name: cards
#
#  id         :bigint           not null, primary key
#  month_date :integer
#  name       :string(255)
#  pay_date   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_cards_on_account_id  (account_id)
#  index_cards_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#
class Card < ApplicationRecord
  belongs_to :user
  belongs_to :account
  has_many :events
  has_many :account_exchanges
  has_many :fund_user_histories

  validates :name, presence: {message: "は１文字以上入力してください。"}, 
  uniqueness: { scope: :user, message: "「%{value}」と同じ名前のカードが存在します。" }
  validates :pay_date, presence: true,
  numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 31
  }
  validates :month_date, presence: true,
  numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 31,
  }
  validate :pay_not_equal_to_month, :card_name_not_account_name

  def before_destroy_action
    events.each do |event|
      event.update(card_id: nil)
    end
    account_exchanges.each do |ax|
      ax.update(card_id: nil)
    end
    fund_user_histories.each do |fund_user_history|
      fund_user_history.update(card_id: nil)
    end
  end

  def after_update_action
    events.includes(:card, :account).each do |event|
      event.update(
        pay_date: event.decide_pay_day,
      )
      event.change_pon
      unless event.pon
        event.update(account_id: account_id)
      end
    end
    account_exchanges.includes(:card, :account).each do |ax|
      ax.update(
        pay_date: ax.decide_pay_day,
      )
      ax.change_pon
      unless ax.pon
        ax.update(source_id: account_id)
      end
    end
    fund_user_histories.includes(:card, :account).each do |fund_user_history|
      fund_user_history.update(
        pay_date: fund_user_history.decide_pay_day,
        account_id: account_id
      )
      fund_user_history.change_pon
      unless fund_user_history.pon
        fund_user_history.update(account_id: account_id)
      end
    end
  end

  # for show----------------------------------------------------------
  def not_pay_dates
    not_pay_date_array = []

    if events.where(pon: false).exists?
      events.where(pon: false).each do |event|
        not_pay_date_array.push(event.pay_date)
      end
    end
    if account_exchanges.where(pon: false).exists?
      account_exchanges.where(pon: false).each do |ax|
        not_pay_date_array.push(ax.pay_date)
      end
    end
    if fund_user_histories.where(pon: false).exists?
      fund_user_histories.where(pon: false).each do |fund_user_history|
        not_pay_date_array.push(fund_user_history.pay_date)
      end
    end

    return not_pay_date_array.uniq.sort
  end

  def not_pay_value(pay_date)
    event = events.where(pon: false, pay_date: pay_date).sum(:value)
    ax = account_exchanges.where(pon: false, pay_date: pay_date).sum(:value)
    fund_user_history = fund_user_histories.where(pon: false, pay_date: pay_date).sum(:value)
    return event + ax + fund_user_history
  end
  # -----------------------------------------------------------------

  private
    def pay_not_equal_to_month
      if pay_date == month_date
        errors.add(:month_date, "と引き落とし日を別にしてください。")
      end
    end

    def card_name_not_account_name
      Account.all.each do |account|
        if account.name == name
          errors.add(:name, "はアカウントでも使用されているので使えません。")
        end
      end  
    end
    
end
