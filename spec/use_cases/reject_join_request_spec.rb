require 'spec_helper'

describe RunPal::RejectJoinRequest do

  before :each do
    RunPal.db.clear_everything
  end

  it 'deletes a join request' do
    user1 = RunPal.db.create_user({username:"Isaac", gender: 2, email: "isaac@smarty.com"})
    user2 = RunPal.db.create_user({username:"Newton", gender: 2, email: "karl@smarty.com"})
    circle = RunPal.db.create_circle({name: "MakerSquare", admin_id: user1.id, max_members: 30, latitude: 33.99, longitude: -9.34, description: "We teach code.", level: -1})
    join_req = RunPal.db.create_join_req({user_id: user2.id, circle_id: circle.id})

    result = subject.run({join_req_id: join_req.id, user_id: user1.id})

    expect(result.success?).to eq(true)
    expect(result.deleted_req.circle_id).to eq(circle.id)
  end

end
