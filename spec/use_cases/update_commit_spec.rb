require 'spec_helper'

describe RunPal::UpdateCommit do

  before :each do
    RunPal.db.clear_everything
  end

  it 'updates a commitment' do
    user = RunPal.db.create_user({first_name:"Isaac Asimov", gender: 2, email: "write@smarty.com"})
    post = RunPal.db.create_post({latitude: 30.25, longitude: -97.75, creator_id: user.id, max_runners: 10, time: Time.now, pace: 3, notes: "Fun!", min_amt: 12.50, age_pref: 3, gender_pref: 0})
    commit  = RunPal.db.create_commit({user_id: user.id, post_id: post.id, amount: 20})

    result = subject.run({commit_id: commit.id, user_id: user.id, amount: 17.31})
    expect(result.success?).to eq(true)
    expect(result.commit.post_id).to eq(post.id)
    expect(result.commit.amount).to eq(17.31)
  end

end
