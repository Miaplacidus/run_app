module RunPal
  class User < Entity
    attr_accessor :id, :username, :gender, :email, :bday, :rating, :level
    # Facebook related properties
    attr_accessor :fbid, :oauth_token, :oauth_expires_at, :img_url

    # Level has same metric as pace
    validates_presence_of :username, :gender, :email, :bday
  end
end

=begin
GENDER
0 - Not Provided
1 - Female
2 - Male
=end
