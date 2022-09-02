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
  has_many :shortcuts, dependent: :destroy
  has_many :account_exchanges
  has_many :fund_user_histories

  validates :name,
            presence: {
              message: 'は１文字以上入力してください。'
            },
            uniqueness: {
              scope: :user,
              message: '「%{value}」と同じ名前のカードが存在します。',
              case_sensitive: false
            }
  validates :pay_date,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 31
            }
  validates :month_date,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 31
            }
  validate :pay_not_equal_to_month, :card_name_not_account_name, :same_user

  before_destroy do
    if events.any?{ |e| !e.payed? } ||
      account_exchanges.any?{ |e| !e.payed? } ||
      fund_user_histories.any?{ |e| !e.payed? }
      throw :abort
    else
      before_destroy_action
    end
  end

  after_update do
    after_update_action
  end

  def before_destroy_action
    events.each { |event| event.update(card_id: nil) }
    account_exchanges.each { |ax| ax.update(card_id: nil) }
    fund_user_histories.each do |fund_user_history|
      fund_user_history.update(card_id: nil)
    end
  end

  def after_update_action
    events
      .includes(:card, :account)
      .each do |event|
        unless event.payed?
          event.update_columns(pay_date: event.decide_pay_day)
          event.update_columns(account_id: account_id)
        end
      end
    account_exchanges
      .includes(:card, :account)
      .each do |ax|
        unless ax.payed?
          ax.update_columns(pay_date: ax.decide_pay_day)
          ax.update_columns(source_id: account_id)
        end
      end
    fund_user_histories
      .includes(:card, :account)
      .each do |fund_user_history|
        unless fund_user_history.payed?
          fund_user_history.update_columns(pay_date: fund_user_history.decide_pay_day)
          fund_user_history.update_columns(account_id: account_id)
        end
      end
  end

  # for show----------------------------------------------------------
  def not_pay_dates
    not_pay_date_array = []

    if events.select{ |e| !e.payed? }.any?
      events
        .select{ |e| !e.payed? }
        .each { |event| not_pay_date_array.push(event.pay_date) }
    end
    if account_exchanges.select{ |e| !e.payed? }.any?
      account_exchanges
        .select{ |e| !e.payed? }
        .each { |ax| not_pay_date_array.push(ax.pay_date) }
    end
    if fund_user_histories.select{ |e| !e.payed? }.any?
      fund_user_histories
        .select{ |e| !e.payed? }
        .each do |fund_user_history|
          not_pay_date_array.push(fund_user_history.pay_date)
        end
    end

    return not_pay_date_array.uniq.sort
  end

  def not_pay_value(pay_date)
    event = events.where(pay_date: pay_date).select{ |e| !e.payed? }.sum(&:value)
    ax = account_exchanges.where(pay_date: pay_date).select{ |e| !e.payed? }.sum(&:value)
    fund_user_history =
      fund_user_histories.where(pay_date: pay_date).select{ |e| !e.payed? }.sum(&:value)
    return event + ax + fund_user_history
  end

  # -----------------------------------------------------------------

  private

  def pay_not_equal_to_month
    if pay_date == month_date
      errors.add(:month_date, 'と引き落とし日を別にしてください。')
    end
  end

  def card_name_not_account_name
    user.accounts.each do |account|
      if account.name == name
        errors.add(:name, 'はアカウントでも使用されているので使えません。')
      end
    end
  end

  def same_user
    user_ids = [user_id]
    account && user_ids << account.user_id

    if user_ids.uniq.size != 1
      errors.add(:user_id, ' different')
    end
  end
end
