require 'spec_helper'

describe RunPal::GetUserPosts do

  before :each do
    RunPal.db.clear_everything
  end

  it "gets posts to which a user is committed" do
    user1 = RunPal.db.create_user({first_name:"Isaac", gender: 2, email: "write@smarty.com", bday: "02/08/1987"})
    user2 = RunPal.db.create_user({first_name:"Sophie", gender: 1, email: "wise@mountain.com", bday: "03/14/1989"})

    post1 = RunPal.db.create_post({latitude: 30.25, longitude: -97.75, creator_id: user1.id, max_runners: 10, time: Time.now, pace: 0, notes: "Fun!", min_amt: 12.50, age_pref: 2, gender_pref: 0})
    post2 = RunPal.db.create_post({creator_id: user1.id, time: Time.now, latitude: 30.251, longitude:-97.751, pace: 1, notes:"Let's go.", complete:false, min_amt:5.50, age_pref: 1, gender_pref: 1})
    post3 = RunPal.db.create_post({creator_id: user1.id, time: Time.now-7200, latitude: 66, longitude: 77, pace: 0, notes:"Will be a fairly relaxed jog.", complete:true, min_amt:12.00, age_pref: 2, gender_pref: 0})

    commit1 = RunPal.db.create_commit({user_id: user2.id, post_id: post1.id, amount: 19.90})
    commit2 = RunPal.db.create_commit({user_id: user2.id, post_id: post2.id, amount: 20.90})
    commit3 = RunPal.db.create_commit({user_id: user2.id, post_id: post3.id, amount: 20.90})

    result = subject.run({user_id: user2.id})
    expect(result.success?).to eq(true)
    expect(result.posts.length).to eq(2)
    expect(result.posts.map &:notes).to include("Fun!", "Let's go.")
  end

end
