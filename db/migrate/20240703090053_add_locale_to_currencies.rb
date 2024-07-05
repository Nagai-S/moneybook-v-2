class AddLocaleToCurrencies < ActiveRecord::Migration[6.0]
  def change
    add_column :currencies, :locale, :string
    Currency.find(1).update(locale: 'ja')
    Currency.find(2).update(locale: 'de')
    end
  end
end
