class AddDefaultToCommitments < ActiveRecord::Migration
  def change
    change_column("commitments", "fulfilled", :boolean, default: false)
  end
end
