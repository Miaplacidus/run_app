require 'spec_helper'

describe RunPal::ShowCircleChallenges do

  before :each do
    RunPal.db.clear_everything
  end

  it "shows a circle's challenges" do
    user1 = RunPal.db.create_user({first_name:"Isaac", gender: 2, email: "isaac@smarty.com"})
    user2 = RunPal.db.create_user({first_name:"Asimov", gender: 2, email: "karl@smarty.com"})
    circle1 = RunPal.db.create_circle({name: "MakerSquare", admin_id: user1.id, max_members: 30, latitude: 33.99, longitude: -9.34, description: "We teach code.", level: -1})
    circle2 = RunPal.db.create_circle({name: "MassRelevance", admin_id: user2.id, max_members: 30, latitude: -33.49, longitude: -9.22, description: "We ship code", level: -1})
    challenge = RunPal.db.create_challenge({name: "n00b Runner Beatdown", sender_id: circle1.id, recipient_id: circle2.id})

    result = subject.run({ user_id: user2.id, circle_id: circle2.id})
    expect(result.success?).to eq(true)
    expect(result.rec_challenges.length).to eq(1)
    expect(result.sent_challenges.length).to eq(0)
    expect(result.rec_challenges[0].name).to eq("n00b Runner Beatdown")

    result = subject.run({user_id: user1.id, circle_id: circle1.id})
    expect(result.success?).to eq(true)
    expect(result.rec_challenges.length).to eq(0)
    expect(result.sent_challenges.length).to eq(1)
    expect(result.sent_challenges[0].name).to eq("n00b Runner Beatdown")
  end

end
