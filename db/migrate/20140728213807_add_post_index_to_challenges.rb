class AddPostIndexToChallenges < ActiveRecord::Migration
  def change
    add_index("challenges", "post_id")
  end
end
