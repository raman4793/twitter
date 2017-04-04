class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :uname
      t.string :email
      t.string :sex
      t.date :dob
      t.string :country
      t.string :state
      t.string :city
      t.string :mobile
      t.string :status
      t.string :description
      t.datetime :last_login_at
      t.datetime :last_logout_at

      t.timestamps
    end
  end
end
