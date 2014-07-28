class RenameUserIdInPosts < ActiveRecord::Migration
  def change
    rename_column("posts", "user_id", "creator_id")
  end
end
