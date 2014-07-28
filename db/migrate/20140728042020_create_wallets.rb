class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.belongs_to :user
      t.float :balance

      t.timestamps
    end
  end
end
