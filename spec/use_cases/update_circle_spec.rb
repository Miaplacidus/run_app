require 'spec_helper'

describe RunPal::UpdateCircle do

  before :each do
    RunPal.db.clear_everything
    @user1 = RunPal.db.create_user({username:"Isaac Asimov", gender: 2, email: "write@smarty.com"})
    @circle = RunPal.db.create_circle({name: "MakerSquare", admin_id: @user1.id, max_members: 3})
  end

  it 'updates a circle' do
    result = subject.run({circle_id: @circle.id, name: "Google", max_members: 25, user_id: @user1.id})

    expect(result.success?).to eq(true)
    expect(result.circle.max_members).to eq(25)
    expect(result.circle.name).to eq("Google")
  end

end
