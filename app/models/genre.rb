class Genre < ApplicationRecord
  belongs_to :user
  has_many :events

  validates :name, presence: {message: "は１文字以上入力してください。"}, 
  uniqueness: { scope: :user, message: "「%{value}」と同じ名前のジャンルが存在します。" }

  def before_destroy_action
    self.events.each do |event|
      event.update(genre_id: nil)
    end
  end
end
