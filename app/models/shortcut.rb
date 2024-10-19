# == Schema Information
#
# Table name: shortcuts
#
#  id         :bigint           not null, primary key
#  iae        :boolean
#  token      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#  card_id    :bigint
#  genre_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_shortcuts_on_account_id  (account_id)
#  index_shortcuts_on_card_id     (card_id)
#  index_shortcuts_on_genre_id    (genre_id)
#  index_shortcuts_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (genre_id => genres.id)
#  fk_rails_...  (user_id => users.id)
#
class Shortcut < ApplicationRecord
  include ApplicationHelper

  belongs_to :user
  belongs_to :card, optional: true
  belongs_to :genre
  belongs_to :account

  validates :token, presence: true
  validate :iae_equal_to_genre_iae, :same_user

  def self.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def create_token
    token = Shortcut.new_token
    digest = Shortcut.digest token
    self.token = digest
    return token
  end

  def valid_token?(sent_token)
    return BCrypt::Password.new(token).is_password?(sent_token)
  end

  def run_shortcut(memo, value)
    signed_value = iae ? value : -value.to_f
    event = user.events.create(
      iae: iae,
      genre_id: genre_id,
      account_id: account_id,
      card_id: card_id,
      date: today(user),
      memo: memo,
      value: signed_value,
      pay_value: signed_value,
      currency_id: account.currency_id,
      pay_currency_id: account.currency_id
    )
    event.after_change_action
  end

  def payment_source_name
    if card
      card.name
    elsif account
      account.name
    end
  end

  private

  def iae_equal_to_genre_iae
    if genre.iae != iae
      errors.add(:genre_id, '支出・収入にあったジャンルを使用してください。')
    end
  end

  def same_user
    user_ids = [user_id,account.user_id,genre.user_id]
    card && user_ids << card.user_id

    if user_ids.uniq.size != 1
      errors.add(:user_id, ' different')
    end
  end
end
