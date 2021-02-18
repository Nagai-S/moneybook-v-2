class AccountExchange < ApplicationRecord
  require 'function_for_change'
  include FunctionForChange
  
  belongs_to :user
  belongs_to :card, optional: true
  belongs_to :account, class_name:"Account", optional: true , foreign_key: :source_id
  belongs_to :to_account, class_name:"Account", optional: true, foreign_key: :to_id

  default_scope -> {order(date: :desc)}
  
  validates :date, presence: true
  validates :value, presence: {message: "は一桁以上入力してください。"},
  numericality: {
    message: "は半角数字で入力してください。", 
    only_integer: {message: "は整数で入力してください。"}
  }
  validate :source_not_equal_to_to

  def iae
    return false
  end

  def before_change_for_toAccount
    return {account: self.to_account, value: -self.value}
  end

  private
    def source_not_equal_to_to
      if source_id==to_id
        errors.add(:source_id, "と振替先アカウントを別にしてください。")
      end
    end
end



