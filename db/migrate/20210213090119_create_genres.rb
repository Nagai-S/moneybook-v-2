class CreateGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :genres do |t|
      t.string :name
      t.boolean :iae, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
