require 'spec_helper'

describe RunPal::FilterPostsByAge do

  before :each do
    RunPal.db.clear_everything
  end

  it 'filters posts by age' do
    user = RunPal.db.create_user({username:"Isaac Asimov", gender: 2, email: "write@smarty.com", bday: "02/08/1987"})
    post1 = RunPal.db.create_post({latitude: 30.25, longitude: -97.75, creator_id: user.id, max_runners: 10, time: Time.now, pace: 3, notes: "Fun!", min_amt: 12.50, age_pref: 2, gender_pref: 0})
    post2 = RunPal.db.create_post({creator_id: user.id, time: Time.now, latitude: 30.251, longitude:-97.751, pace: 1, notes:"Let's go.", complete:false, min_amt:5.50, age_pref: 1, gender_pref: 1})
    post3 = RunPal.db.create_post({creator_id: user.id, time: Time.now, latitude: 66, longitude: 77, pace: 3, notes:"Will be a fairly relaxed jog.", complete:true, min_amt:12.00, age_pref: 2, gender_pref: 2})

    result = subject.run({radius: 3, user_lat: 66.0001, user_long: 77.0001, user_id: user.id, gender_pref: 3})
    expect(result.success?).to eq(true)

    expect(result.post_arr.length).to eq(1)
    expect(result.post_arr[0].notes).to eq("Will be a fairly relaxed jog.")
  end

end
