class CreateCircleUsers < ActiveRecord::Migration
  def change
    create_table :circle_users do |t|
      t.belongs_to :circle
      t.belongs_to :user

      t.timestamps
    end
  end
end
