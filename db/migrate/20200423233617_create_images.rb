class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.references :subreddit, null: false, foreign_key: true
      t.text :caption
      t.integer :upvotes

      t.timestamps
    end
  end
end
