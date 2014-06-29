require 'spec_helper'

describe RunPal::ShowOpenCircles do

    before :each do
        RunPal.db.clear_everything
    end

  it 'shows open circles' do
    user = RunPal.db.create_user({username:"Isaac Asimov", gender: 2, email: "write@smarty.com"})
    circle1 = RunPal.db.create_circle({name: "Silvercar", admin_id: user.id, max_members: 1, latitude: 32, longitude:44})
    circle2 = RunPal.db.create_circle({name: "Crazy Apps", admin_id: user.id, max_members: 19, latitude: 22, longitude: 67})
    RunPal.db.add_users_to_circle(circle1.id, [user.id])

    result = subject.run({user_lat: 22.001, user_long: 67.001, radius: 3})
    expect(result.success?).to eq(true)
    expect(result.circle_arr.length).to eq(1)
    expect(result.circle_arr[0].name).to eq("Crazy Apps")
  end

end

