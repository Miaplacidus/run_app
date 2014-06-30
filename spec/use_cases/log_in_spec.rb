require 'spec_helper'

describe RunPal::LogIn do

  before :each do
    RunPal.db.clear_everything
    OmniAuth.config.test_mode = true

      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        :provider => 'facebook',
        :uid => '1234567',
        :info => {
          :first_name => "Sophie",
          :image => 'http://graph.facebook.com/1234567/picture?type=square'
        },
        :credentials => {
          :token => 'ABCDEF',
          :expires_at => 12262551311
        },
        :extra => {
          :raw_info => {
            :gender => 'female',
            :email => "sophie@internet.com",
            :birthday => "03/14/1988"
          }
        }
      })
  end

  it 'logs a user in' do
    auth = OmniAuth.config.mock_auth[:facebook]
    result = subject.run({auth: auth})

    expect(result.user.first_name).to eq("Sophie")
    expect(result.user.bday).to eq("03/14/1988")
  end

end
