class AddDefaultsToPosts < ActiveRecord::Migration
  def change
    change_column("posts", "notes", :text, default: '')
    change_column("posts", "circle_id", :integer, default: nil)
  end
end
