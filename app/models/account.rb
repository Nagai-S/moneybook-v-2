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
  has_many :fund_user_histories
  has_many :account_exchanges_to, class_name:"AccountExchange", foreign_key: :to_id
  has_many :account_exchanges_source, class_name:"AccountExchange", foreign_key: :source_id

  default_scope -> {order(value: :desc)}

  validates :name, presence: {message: "は１文字以上入力してください。"}, 
  uniqueness: { scope: :user, message: "「%{value}」と同じ名前のアカウントが存在します。" }
  validates :value, presence: {message: "は１桁以上入力してください。"}, 
  numericality: {
    message: "は半角数字で入力してください。", 
    only_integer: {message: "は整数で入力してください。"}
  }

  def plus(set_value)
    now_value = value
    update(value: now_value + set_value)
  end
  
  def after_pay_value
    not_pay_value = 0
    cards.includes(:events, :account_exchanges).each do |card|
      not_pay_value += card.events.where(pon: false).sum(:value)
      not_pay_value += card.account_exchanges.where(pon: false).sum(:value)
      not_pay_value += card.fund_user_histories.where(pon: false).sum(:value)
    end
    return value - not_pay_value
  end

  def before_destroy_action
    events.each do |event|
      event.update(account_id: nil)
    end
    account_exchanges_to.each do |ax|
      ax.update(to_id: nil)
    end
    account_exchanges_source.each do |ax|
      ax.update(source_id: nil)
    end
  end
  
end
