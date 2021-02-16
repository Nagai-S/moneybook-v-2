class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.date :date
      t.date :pay_date
      t.string :memo
      t.integer :value
      t.boolean :iae, default: false
      t.boolean :pon, default: false
      t.references :user, null: false, foreign_key: true
      t.references :genre, null: true
      t.references :account, null: true
      t.references :card, null: true

      t.timestamps
    end
  end
end
