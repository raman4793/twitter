class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.references :user, foreign_key: true
      t.string :msg
      t.integer :eventable_id
      t.string :eventable_type

      t.timestamps
    end
  end
end
