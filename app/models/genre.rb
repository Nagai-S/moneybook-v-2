class Genre < ApplicationRecord
  belongs_to :user
  has_many :events

  validates :name, presence: {message: "は１文字以上入力してください。"}, 
  uniqueness: { scope: :user, message: "「%{value}」と同じ名前のジャンルが存在します。" }
end
