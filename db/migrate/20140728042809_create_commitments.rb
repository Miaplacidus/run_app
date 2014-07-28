class CreateCommitments < ActiveRecord::Migration
  def change
    create_table :commitments do |t|
      t.float :amount
      t.boolean :fulfilled

      t.belongs_to :post
      t.belongs_to :user
    end
    add_index("commitments", "post_id")
    add_index("commitments", "user_id")
  end
end
