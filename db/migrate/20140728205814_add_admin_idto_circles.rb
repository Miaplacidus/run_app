class AddAdminIdtoCircles < ActiveRecord::Migration
  def change
     add_column("circles", "admin_id", :integer)
  end
end
