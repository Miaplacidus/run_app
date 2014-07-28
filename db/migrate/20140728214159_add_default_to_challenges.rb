class AddDefaultToChallenges < ActiveRecord::Migration
  def change
    change_column("challenges", "state", :string, default: 'pending')
    change_column("challenges", "notes", :text, default: '')
  end
end
