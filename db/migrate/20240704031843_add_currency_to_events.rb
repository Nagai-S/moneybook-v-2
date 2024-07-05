class AddCurrencyToEvents < ActiveRecord::Migration[6.0]
  def change
    add_reference :events, :currency, null: false
    Event.find_each do |event|
      event.currency_id = 1
      event.save!
    end
  end
end
