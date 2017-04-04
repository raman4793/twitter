class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.references :user, foreign_key: true
      t.integer :reported_id
      t.string :reason

      t.timestamps
    end
  end
end
