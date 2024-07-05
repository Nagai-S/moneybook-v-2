class CreateCurrencies < ActiveRecord::Migration[6.0]
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :mark

      t.timestamps
    end
    Currency.create(name: 'JPY', mark: '¥', id: 1)
    Currency.create(name: 'EUR', mark: '€', id: 2)
  end
end
