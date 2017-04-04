class CreateBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :blocks do |t|
      t.references :user, foreign_key: true
      t.integer :blocked_id
      t.string :reason

      t.timestamps
    end
  end
end
