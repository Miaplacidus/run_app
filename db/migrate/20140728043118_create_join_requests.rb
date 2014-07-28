class CreateJoinRequests < ActiveRecord::Migration
  def change
    create_table :join_requests do |t|
      t.belongs_to :circle
      t.belongs_to :user
      t.boolean :accepted

      t.timestamps
    end

    add_index("join_requests", "user_id")
    add_index("join_requests", "circle_id")
  end
end
