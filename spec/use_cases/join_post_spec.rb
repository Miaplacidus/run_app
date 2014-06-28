require 'spec_helper'

describe RunPal::JoinPost do

  before :each do
    RunPal.db.clear_everything
  end

  it 'lets a user join a post/creates a commitment' do
    user1 = RunPal.db.create_user({first_name:"Isaac", gender: 2, email: "gravity@apple.com"})
    user2 = RunPal.db.create_user({first_name:"Albert", gender: 2, email: "time@space.com"})
    post = RunPal.db.create_post({latitude:30.25, longitude: -97.75, creator_id: user1.id, max_runners: 10, time: Time.now, pace: 3, notes: "Exercise!", min_amt: 3.14, age_pref: 3, gender_pref: 0, min_distance: 8})

    result = subject.run({user_id: user2.id, post_id: post.id, amount: 6.30})

    expect(result.success?).to eq(true)
    expect(result.post.max_runners).to eq(10)
    expect(result.commit.amount).to eq(6.30)
  end

end
