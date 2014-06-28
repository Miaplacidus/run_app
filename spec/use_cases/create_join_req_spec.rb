require 'spec_helper'

describe RunPal::CreateJoinReq do

  before :each do
    RunPal.db.clear_everything
  end

  it 'creates a new join request for a circle' do
    user1 = RunPal.db.create_user({username:"Isaac", gender: 2, email: "isaac@smarty.com"})
    user2 = RunPal.db.create_user({username:"Newton", gender: 2, email: "karl@smarty.com"})
    circle1 = RunPal.db.create_circle({name: "MakerSquare", admin_id: user1.id, max_members: 30, latitude: 33.99, longitude: -9.34, description: "We teach code.", level: -1})

    result = subject.run({ user_id: user2.id, circle_id: circle1.id})
    expect(result.success?).to eq(true)
    expect(result.join_req.user_id).to eq(user2.id)
    expect(result.join_req.circle_id).to eq(circle1.id)
  end

end
