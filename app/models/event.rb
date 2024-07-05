# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  date        :date
#  iae         :boolean          default(FALSE)
#  memo        :string(255)
#  pay_date    :date
#  value       :decimal(10, 2)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint
#  card_id     :bigint
#  currency_id :bigint           not null
#  genre_id    :bigint
#  user_id     :bigint           not null
#
# Indexes
#
#  index_events_on_account_id   (account_id)
#  index_events_on_card_id      (card_id)
#  index_events_on_currency_id  (currency_id)
#  index_events_on_genre_id     (genre_id)
#  index_events_on_user_id      (user_id)
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
  belongs_to :currency

  default_scope -> { order(date: :desc) }

  validates :date, presence: true
  validates(
    :value,
    presence: {
      message: 'は一桁以上入力してください。'
    },
    numericality: {
      message: 'は半角数字で入力してください。',
    }
  )
  validate :iae_equal_to_genre_iae, :same_user, :same_currency

  after_save { after_change_action }

  def payment_source_name
    if card
      card.name
    elsif account
      account.name
    else
      '削除済み'
    end
  end

  def genre_name
    genre ? genre.name : '削除済み'
  end

  def scale_factor
    return currency_id == user.currency_id ? 1 : (
      CurrencyExchange.find_by(unit_id: currency_id, to_id: user.currency_id).value
    )
  end

  private

  def iae_equal_to_genre_iae
    if genre_id != nil && genre.iae != iae
      errors.add(:genre_id, '支出・収入にあったジャンルを使用してください。')
    end
  end

  def same_user
    user_ids = [user_id]
    account && user_ids << account.user_id
    genre && user_ids << genre.user_id
    card && user_ids << card.user_id

    if user_ids.uniq.size != 1
      errors.add(:user_id, ' different')
    end
  end

  def same_currency
    if account_id != nil && account.currency_id != currency_id
      errors.add(:currency_id, 'アカウントの通貨と異なります')
    end
  end

end
