require 'spec_helper'

describe RunPal::CreateCircle do

  before :each do
    RunPal.db.clear_everything
  end

  it 'creates a new circle' do
    user = RunPal.db.create_user({first_name:"Isaac Asimov", gender: 2, email: "write@smarty.com"})
    result = subject.run({name: "MakerSquare", latitude: 30.25, longitude: -97.75, user_id: user.id, max_members: 45, description:"We're super fun", level: 3, city: "Everytown, GA, USA"})

    expect(result.success?).to eq(true)
    expect(result.circle.name).to eq("MakerSquare")
    expect(result.circle.latitude).to eq(30.25)
  end

end
