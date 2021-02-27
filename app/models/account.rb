class Account < ApplicationRecord
  belongs_to :user
  has_many :cards
  has_many :events, dependent: :destroy
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

  def plus(value)
    now_value=self.value
    self.update(value: now_value+value)
  end
  
  def after_pay_value
    not_pay_value=0
    self.cards.includes(:events, :account_exchanges).each do |card|
      not_pay_value+=card.events.where(pon: false).sum(:value)
      not_pay_value+=card.account_exchanges.where(pon: false).sum(:value)
    end
    return self.value-not_pay_value
  end
  
end
