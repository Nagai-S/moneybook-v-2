class CreateFundUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :fund_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :fund, null: false, foreign_key: true
      t.decimal :average_buy_value, precision: 10, scale: 2

      t.timestamps
    end
  end
end
