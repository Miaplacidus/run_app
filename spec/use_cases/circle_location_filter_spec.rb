require 'spec_helper'

describe RunPal::FilterCirclesByLocation do

    before :each do
        RunPal.db.clear_everything
    end

  it 'filters circles by location' do
    user = RunPal.db.create_user({username:"Isaac Asimov", gender: 2, email: "write@smarty.com"})
    circle1 = RunPal.db.create_circle({name: "Silvercar", admin_id: user.id, max_members: 1, latitude: 32, longitude:44})
    circle2 = RunPal.db.create_circle({name: "Crazy Apps", admin_id: user.id, max_members: 19, latitude: 22, longitude: 67})

    result = subject.run({user_lat: 32.011, user_long: 44.001, radius: 3})
    expect(result.success?).to eq(true)
    expect(result.circle_arr.length).to eq(1)
    expect(result.circle_arr[0].name).to eq("Silvercar")
  end

end

