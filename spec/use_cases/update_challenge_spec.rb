require 'spec_helper'

describe RunPal::UpdateChallenge do

  before :each do
    RunPal.db.clear_everything
  end

  it 'updates a challenge' do
    user1 = RunPal.db.create_user({first_name:"Isaac", gender: 2, email: "isaac@smarty.com"})
    user2 = RunPal.db.create_user({first_name:"Newton", gender: 2, email: "karl@smarty.com"})
    circle1 = RunPal.db.create_circle({name: "MakerSquare", admin_id: user1.id, max_members: 30, latitude: 33.99, longitude: -9.34, description: "We teach code.", level: -1})
    circle2 = RunPal.db.create_circle({name: "MassRelevance", admin_id: user2.id, max_members: 30, latitude: -33.49, longitude: -9.22, description: "We ship code", level: -1})
    challenge = RunPal.db.create_challenge({name: "Maker-Mass Challenge", sender_id: circle1.id, recipient_id: circle2.id, notes:"Whoop yo ass!"})

    result = subject.run({name:"Fitness Challenge", notes: "Prepare to LOSE!", user_id: user1.id, challenge_id: challenge.id})
    expect(result.success?).to eq(true)
    expect(result.challenge.name).to eq("Fitness Challenge")
  end

end
