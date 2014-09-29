class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_hash
      t.string :password_salt
      t.string :gender
      t.string :email
      t.string :phone_number
      t.string :subject
      t.date :date_of_birth

      t.timestamps
    end
  end
end
