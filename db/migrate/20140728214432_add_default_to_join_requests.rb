class AddDefaultToJoinRequests < ActiveRecord::Migration
  def change
    change_column("join_requests", "accepted", :boolean, default: false)
  end
end
