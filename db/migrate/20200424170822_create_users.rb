class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password_hash
      t.boolean :is_mod
      t.integer :liked_comments, array: true, default: []
      t.integer :disliked_comments, array: true, default: []

      t.timestamps
    end
  end
end
