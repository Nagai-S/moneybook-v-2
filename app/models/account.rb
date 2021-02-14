class Account < ApplicationRecord
  belongs_to :user

  default_scope -> {order(value: :desc)}

  validates :name, presence: {message: "は１文字以上入力してください。"}, 
  uniqueness: { scope: :user, message: "「%{value}」と同じ名前のアカウントが存在します。" }
  validates :value, presence: {message: "は１桁以上入力してください。"}, 
  numericality: {
    message: "は半角数字で入力してください。", 
    only_integer: {message: "は整数で入力してください。"}
  }
end
