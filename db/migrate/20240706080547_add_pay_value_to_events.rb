class AddPayValueToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :pay_value, :decimal, precision: 10, scale: 2
    add_reference :events, :pay_currency, foreign_key: {to_table: :currencies}
    Event.find_each do |event|
      event.pay_value = event.value
      event.pay_currency_id = event.currency_id
      event.save!
    end
  end
end
