module RunPal
  class User < Entity
    attr_accessor :id, :rating, :level
    # Facebook-extracted properties
    attr_accessor :first_name, :gender, :email, :bday
    attr_accessor :fbid, :oauth_token, :oauth_expires_at, :img_url

    # Level has same metric as pace
    validates :email, presence: true, format: { with: /\A[\w+\.]+@[a-z\d\.]+\.[a-z]+\z/i }
    validates_presence_of :first_name, :gender, :bday
  end
end

=begin
GENDER
0 - Not Provided
1 - Female
2 - Male
=end
