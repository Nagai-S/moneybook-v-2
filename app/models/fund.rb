class Fund < ApplicationRecord
  validates :name, presence: {message: "は１文字以上入力してください。"}
  default_scope -> {order("RAND()")}
end
