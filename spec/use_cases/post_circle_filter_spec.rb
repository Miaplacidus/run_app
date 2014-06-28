require 'spec_helper'

describe RunPal::FilterPostsByCircle do

  before :each do
    RunPal.db.clear_everything
  end

  it 'filters posts by circle' do
    user1 = RunPal.db.create_user({first_name:"Isaac Asimov", gender: 2, email: "write@smarty.com", bday: "02/08/1987"})
    user2 = RunPal.db.create_user({first_name:"Sophie Wise", gender: 1, email: "wise@mountain.com", bday: "03/14/1989"})
    circle1 = RunPal.db.create_circle({name: "MakerSquare", admin_id: user1.id, max_members: 30, latitude: 33.99, longitude: -9.34, description: "We teach code.", level: -1})

    post1 = RunPal.db.create_post({latitude: 30.25, longitude: -97.75, creator_id: user1.id, max_runners: 10, time: Time.now, pace: 3, notes: "Fun!", min_amt: 12.50, age_pref: 2, gender_pref: 0})
    post2 = RunPal.db.create_post({creator_id: user1.id, time: Time.now, latitude: 30.251, longitude:-97.751, pace: 1, notes:"Let's go.", complete:false, min_amt:5.50, age_pref: 1, gender_pref: 1, circle_id: circle1.id})
    post3 = RunPal.db.create_post({creator_id: user2.id, time: Time.now, latitude: 66, longitude: 77, pace: 3, notes:"Will be a fairly relaxed jog.", complete:true, min_amt:12.00, age_pref: 2, gender_pref: 2})

    result = subject.run({circle_id: circle1.id, user_id: user2.id})
    expect(result.success?).to eq(true)
    expect(result.post_arr.length).to eq(1)
    expect(result.post_arr[0].notes).to eq("Let's go.")
  end

end
