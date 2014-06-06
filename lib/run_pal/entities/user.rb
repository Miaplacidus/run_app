module RunPal
  class User < Entity
    attr_accessor :id, :rating, :level
    # Facebook-extracted properties
    attr_accessor :first_name, :gender, :email, :bday
    attr_accessor :fbid, :oauth_token, :oauth_expiry, :img_url

    # Level has same metric as pace
    validates :email, presence: true, format: { with: /\A[\w+\.]+@[a-z\d\.]+\.[a-z]+\z/i }
    validates :bday, presence: true, format: { with: /(\d{2})\/(\d{2})\/(\d{4})/ }
    validates_presence_of :first_name, :gender
  end
end

=begin
GENDER
0 - Not Provided
1 - Female
2 - Male
=end
