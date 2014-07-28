class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.integer :gender
      t.string :email
      t.string :bday
      t.integer :rating
      t.integer :level
      t.string :fbid
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.string :img_url

      t.timestamps
    end
  end
end

