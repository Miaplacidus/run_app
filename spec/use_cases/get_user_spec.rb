require 'spec_helper'

describe RunPal::GetUser do

  before :each do
    RunPal.db.clear_everything
  end

  it 'gets a user' do
    user = RunPal.db.create_user({first_name:"Isaac", gender: 2, email: "gravity@apple.com"})
    result = subject.run({user_id: user.id})

    expect(result.success?).to eq(true)
    expect(result.user.first_name).to eq("Isaac")
    expect(result.user.email).to eq('gravity@apple.com')
  end

end
