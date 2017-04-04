class CreateMicropostsTags < ActiveRecord::Migration[5.0]
  def change
    create_table :microposts_tags do |t|
      t.references :micropost, foreign_key: true
      t.references :tag, foreign_key: true
    end
  end
end
