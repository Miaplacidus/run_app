class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.belongs_to :circle
      t.belongs_to :user
      t.datetime :time
      t.float :latitude
      t.float :longitude
      t.integer :pace
      t.text :notes
      t.boolean :complete
      t.float :min_amt
      t.integer :age_pref
      t.integer :gender_pref
      t.integer :max_runners

      t.timestamps
    end

    add_index("posts", "user_id")
    add_index("posts", "circle_id")
  end
end
