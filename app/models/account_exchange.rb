# == Schema Information
#
# Table name: account_exchanges
#
#  id         :bigint           not null, primary key
#  date       :date
#  pay_date   :date
#  pon        :boolean
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  card_id    :bigint
#  source_id  :bigint
#  to_id      :bigint
#  user_id    :bigint           not null
#
# Indexes
#
#  index_account_exchanges_on_card_id    (card_id)
#  index_account_exchanges_on_source_id  (source_id)
#  index_account_exchanges_on_to_id      (to_id)
#  index_account_exchanges_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (source_id => accounts.id)
#  fk_rails_...  (to_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#
class AccountExchange < ApplicationRecord
  include MyFunction::FunctionForChange

  belongs_to :user
  belongs_to :card, optional: true
  belongs_to :account,
             class_name: 'Account',
             optional: true,
             foreign_key: :source_id
  belongs_to :to_account,
             class_name: 'Account',
             optional: true,
             foreign_key: :to_id

  default_scope -> { order(date: :desc) }

  validates :date, presence: true
  validates :value,
            presence: {
              message: 'は一桁以上入力してください。'
            },
            numericality: {
              message: 'は半角数字で入力してください。',
              only_integer: {
                message: 'は整数で入力してください。'
              }
            }

  def source_name
    if card
      card.name
    elsif account
      account.name
    else
      '削除済み'
    end
  end

  def to_account_name
    to_account ? to_account.name : '削除済み'
  end

end
