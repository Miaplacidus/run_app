class AddMinDistanceToPosts < ActiveRecord::Migration
  def change
    add_column("posts", "min_distance", :integer)
  end
end
