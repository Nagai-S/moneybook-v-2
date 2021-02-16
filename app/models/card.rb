class Card < ApplicationRecord
  belongs_to :user
  belongs_to :account
  has_many :events

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

  

  private
    def pay_not_equal_to_month
      if pay_date==month_date
        errors.add(:month_date, "と引き落とし日を別にしてください。")
      end
    end

    def card_name_not_account_name
      Account.all.each do |account|
        if account.name==name
          errors.add(:name, "はアカウントでも使用されているので使えません。")
        end
      end  
    end
    
end
