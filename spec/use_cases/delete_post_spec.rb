require 'spec_helper'

describe RunPal::DeletePost do

  before :each do
    RunPal.db.clear_everything
  end

  it 'deletes a post' do
    user = RunPal.db.create_user({first_name:"Isaac", gender: 2, email: "robot@asimov.com"})
    post = RunPal.db.create_post({latitude:30.25, longitude: -97.75, creator_id: user.id, max_runners: 10, time: Time.now, pace: 3, notes: "Fun!", min_amt: 12.50, age_pref: 3, gender_pref: 0, min_distance: 5})

    result = subject.run({post_id: post.id, user_id: user.id})
    expect(result.success?).to eq(true)
    expect(result.post.max_runners).to eq(10)
    expect(result.post.min_amt).to eq(12.50)
    expect(RunPal.db.get_user(result.post.creator_id).first_name).to eq("Isaac")
  end

end
