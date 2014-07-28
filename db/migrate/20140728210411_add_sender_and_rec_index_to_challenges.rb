class AddSenderAndRecIndexToChallenges < ActiveRecord::Migration
  def change
    add_index("challenges", "sender_id")
    add_index("challenges", "recipient_id")
  end
end
