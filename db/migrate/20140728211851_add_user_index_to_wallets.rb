class AddUserIndexToWallets < ActiveRecord::Migration
  def change
    add_index("wallets", "user_id")
  end
end
