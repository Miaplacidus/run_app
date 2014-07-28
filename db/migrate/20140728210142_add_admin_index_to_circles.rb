class AddAdminIndexToCircles < ActiveRecord::Migration
  def change
    add_index("circles", "admin_id")
  end
end
