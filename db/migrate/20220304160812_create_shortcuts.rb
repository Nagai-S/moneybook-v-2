class CreateShortcuts < ActiveRecord::Migration[6.0]
  def change
    create_table :shortcuts do |t|
      t.string :token
      t.boolean :iae
      t.references :card, null: true
      t.references :account, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
