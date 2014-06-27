# TO DO
require 'spec_helper'

describe RunPal::CheckIn do

  before :each do
    RunPal.db.clear_everything
  end

  xit 'checks a user in to a post if they are nearby' do
    user1 = RunPal.db.create_user({first_name:"Isaac", gender: 2, email: "isaac@smarty.com"})
    user2 = RunPal.db.create_user({first_name:"Asimov", gender: 2, email: "karl@smarty.com"})
    post = RunPal.db.create_post({creator_id: user1.id, max_runners: 10, time: Time.now, pace: 3, notes: "Fun!", min_amt: 12.50, age_pref: 3, gender_pref: 0, latitude: -33.49, longitude: -9.22})
    commit = RunPal.db.create_commit({user_id: user2.id, post_id: post.id})

    result = subject.run({ user_id: user2.id, commit_id: commit.id, user_lat: -33.49, user_long: -9.22 })

    expect(result.success?).to eq(true)
    expect(result.post.max_runners).to eq(10)
    expect(result.commit).to eq("what?")
  end

end
