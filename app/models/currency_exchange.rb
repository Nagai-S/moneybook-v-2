# == Schema Information
#
# Table name: currency_exchanges
#
#  id         :bigint           not null, primary key
#  value      :float(24)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  to_id      :bigint           not null
#  unit_id    :bigint           not null
#
# Indexes
#
#  index_currency_exchanges_on_to_id    (to_id)
#  index_currency_exchanges_on_unit_id  (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (to_id => currencies.id)
#  fk_rails_...  (unit_id => currencies.id)
#

class CurrencyExchange < ApplicationRecord
  belongs_to :account,
             class_name: 'Account',
             optional: true,
             foreign_key: :source_id
  belongs_to :to_account,
             class_name: 'Account',
             optional: true,
             foreign_key: :to_id

  belongs_to :unit, class_name: 'Currency', foreign_key: :unit_id
  belongs_to :to, class_name: 'Currency', foreign_key: :to_id
end
