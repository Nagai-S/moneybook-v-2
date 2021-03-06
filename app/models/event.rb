class Event < ApplicationRecord
  require 'function_for_change'
  include FunctionForChange
  
  belongs_to :user
  belongs_to :card, optional: true
  belongs_to :genre, optional: true
  belongs_to :account, optional: true

  default_scope -> {order(date: :desc)}

  validates :date, presence: true
  validates :value, presence: {message: "は一桁以上入力してください。"},
  numericality: {
    message: "は半角数字で入力してください。", 
    only_integer: {message: "は整数で入力してください。"}
  }

  def to_account
    return false
  end
  
end
