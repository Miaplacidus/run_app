require 'spec_helper'

describe RunPal::WalletTransaction do

  before :each do
      RunPal.db.clear_everything
  end

  it 'updates wallet balance' do
    user = RunPal.db.create_user({username:"Isaac Asimov", gender: 2, email: "write@smarty.com"})
    wallet = RunPal.db.create_wallet({user_id: user.id, balance: 30.50})

    result = subject.run({user_id: user.id, transaction: -20.50})
    expect(result.success?).to eq(true)

    expect(result.wallet.balance).to eq(10.00)
  end

end

