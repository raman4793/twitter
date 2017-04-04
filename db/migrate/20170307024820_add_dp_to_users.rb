class AddDpToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :dp, :string
  end
end
