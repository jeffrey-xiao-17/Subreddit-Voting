class CreateSubreddits < ActiveRecord::Migration[6.0]
  def change
    create_table :subreddits do |t|
      t.string :name
      t.text :description
      t.integer :total_upvotes

      t.timestamps
    end
  end
end
