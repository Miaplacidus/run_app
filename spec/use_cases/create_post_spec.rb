require 'spec_helper'

describe RunPal::CreatePost do

  before :each do
    RunPal.db.clear_everything
  end

  it 'creates a new post' do
    user = RunPal.db.create_user({first_name:"Isaac Asimov", gender: 2, email: "write@smarty.com"})
    result = subject.run({latitude:30.25, longitude: -97.75, user_id: user.id, max_runners: 10, time: Time.now, pace: 3, notes: "Fun!", min_amt: 12.50, age_pref: 3, gender_pref: 0, min_distance: 5})

    puts result
    expect(result.success?).to eq(true)
    expect(result.post.max_runners).to eq(10)
    expect(result.post.min_amt).to eq(12.50)
    expect(RunPal.db.get_user(result.post.creator_id).first_name).to eq("Isaac Asimov")
  end

end
