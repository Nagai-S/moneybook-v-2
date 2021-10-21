# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  date       :date
#  iae        :boolean          default(FALSE)
#  memo       :string(255)
#  pay_date   :date
#  pon        :boolean          default(FALSE)
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint
#  card_id    :bigint
#  genre_id   :bigint
#  user_id    :bigint           not null
#
# Indexes
#
#  index_events_on_account_id  (account_id)
#  index_events_on_card_id     (card_id)
#  index_events_on_genre_id    (genre_id)
#  index_events_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Event < ApplicationRecord
  include MyFunction::FunctionForChange
  
  belongs_to :user
  belongs_to :card, optional: true
  belongs_to :genre, optional: true
  belongs_to :account, optional: true

  default_scope -> {order(date: :desc)}

  validates :date, presence: true
  validates :value, presence: {message: "は一桁以上入力してください。"},
  numericality: {
    message: "は半角数字で入力してください。", 
    only_integer: {message: "は整数で入力してください。"},
    buy_or_sell: true
  }
  validate :iae_equal_to_genre_iae

  def to_account
    return false
  end

  def parents_deleted
    account_deleted
  end

  private
    def iae_equal_to_genre_iae
      if genre_id != nil && genre.iae != iae
        errors.add(:genre_id, "支出・収入にあったジャンルを使用してください。")
      end
    end
  
end
