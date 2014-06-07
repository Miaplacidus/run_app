
shared_examples 'a database' do
  let(:db) { described_class.new}

  before :each do
    db.clear_everything
  end

# USER TESTS
  describe 'Users' do

    before :each do
      users = [
        {first_name: "FastFeet", gender: 1, email:"marathons@speed.com", bday:"02/08/1987", level: 0},
        {first_name: "RunnaLot", gender: 2, email:"jogger@run.com", bday:"06/06/1966"},
        {first_name: "JonJones", gender: 2, email:"runlikemad@sprinter.com", bday:"03/14/1988"},
        {first_name: "NeeUpp", gender: 1, email:"sofast@runna.com", bday: "05/15/1994"}
      ]

      @user_objs = []
      users.each do |attrs|
          @user_objs << db.create_user(attrs)
      end

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

    it "creates a user" do
      user = @user_objs[0]
      expect(user.first_name).to eq("FastFeet")
      expect(user.gender).to eq(1)
      expect(user.level).to eq(0)
      expect(user.email).to eq("marathons@speed.com")
      expect(user.bday).to eq("02/08/1987")
    end

    it "creates a user using facebook info" do
      auth = OmniAuth.config.mock_auth[:facebook]
      user = db.from_omniauth(auth)
      expect(user.first_name).to eq("Sophie")
      expect(user.oauth_token).to eq("ABCDEF")
      expect(user.oauth_expiry).to be_a Time
    end

    it "gets a user" do
      user = @user_objs[1]
      retrieved_user = db.get_user(user.id)
      expect(retrieved_user.first_name).to eq('RunnaLot')
      expect(retrieved_user.bday).to eq('06/06/1966')
    end

    it "gets a user by email" do
      retrieved_user = db.get_user_by_email("jogger@run.com")
      expect(retrieved_user.first_name).to eq("RunnaLot")
      retrieved_user = db.get_user_by_email("email@fake.com")
      expect(retrieved_user).to eq(nil)
    end

    it "gets all users" do
      # %w{Alice Bob}.each {|name| db.create_user :username => name }
      expect(db.all_users.count).to eq(4)
      expect(db.all_users.map &:first_name).to include('FastFeet', 'RunnaLot', 'JonJones', 'NeeUpp')
    end

    it "updates user information" do
      user = @user_objs[2]
      user = db.update_user(user.id, {email:"awesome@running.net"})
      expect(user.email).to eq("awesome@running.net")
      user = db.update_user(user.id, {first_name: "Wiz Khalifa"})
      expect(user.first_name).to eq("Wiz Khalifa")
    end

    it "deletes a user" do
      user = @user_objs[1]
      db.delete_user(user.id)
      expect(db.get_user(user.id)).to eq nil
    end

  end

# POST TESTS
  describe 'Posts' do
    before :each do
      users = [
          {first_name: "FastFeet", gender: 1, email:"marathons@speed.com", bday:"02/08/1987"},
          {first_name: "RunnaLot", gender: 2, email:"jogger@run.com", bday:"06/06/1966"},
          {first_name: "JonJones", gender: 2, email:"runlikemad@sprinter.com", bday:"03/14/1988"},
          {first_name: "NeeUpp", gender: 1, email:"sofast@runna.com", bday: "05/15/1994"}
      ]
      @user_objs = []
      users.each do |info|
          @user_objs << db.create_user(info)
      end

      @t_apr_first = Time.parse("Apr 1 2014")
      @t_may_first = Time.parse("May 1 2014")
      @t_june_first = Time.parse("June 1 2014")
      @t_july_first = Time.parse("July 1 2014")

      posts = [
        {creator_id: @user_objs[0].id, time: @t_apr_first, latitude: 40, longitude: 51, pace: 2, notes:"Sunny day run!", complete:false, min_amt:10.50, age_pref: 0, gender_pref: 0, min_distance: 4},
        {creator_id: @user_objs[1].id, time: @t_may_first, latitude: 44, longitude: 55, pace: 1, notes:"Let's go.", complete:false, min_amt:5.50, age_pref: 3, gender_pref: 1, min_distance: 5},
        {creator_id: @user_objs[2].id, time: @t_june_first, latitude: 66, longitude: 77, pace: 7, notes:"Will be a fairly relaxed jog.", complete:true, min_amt:12.00, age_pref: 3, gender_pref: 1, min_distance: 1},
        {creator_id: @user_objs[3].id, time: @t_july_first, latitude: 88, longitude: 99, pace: 0, complete:false, min_amt:20.00, age_pref: 4, gender_pref: 0, min_distance: 7},
      ]

      @post_objs = []
      posts.each do |attrs|
        @post_objs << db.create_post(attrs)
      end

    end

    it "creates a post" do
      post = @post_objs[0]
      expect((db.get_user(post.creator_id)).first_name).to eq("FastFeet")
      # expect(post.time).to eq()
      expect(post.pace).to eq(2)
      expect(post.min_amt).to eq(10.50)
      expect(post.complete).to eq(false)
      expect(post.circle_id).to eq(nil)
      expect(post.min_distance).to eq(4)
    end

    it "gets a post" do
      post = @post_objs[2]
      result = db.get_post(post.id)
      expect(result.notes).to eq("Will be a fairly relaxed jog.")
      expect(result.gender_pref).to eq(1)
      expect(result.age_pref).to eq(3)
      expect(result.min_amt).to eq(12.00)
    end

    it "gets all posts" do
      result = db.all_posts
      result.count.should eql(4)
      expect(result.map &:gender_pref).to include(0, 1)
    end

    it "updates posts" do
      post = @post_objs[1]
      result = db.update_post(post.id, {age_pref: 4, pace: 3, time: Time.parse("June 5 2015")})
      expect(result.age_pref).to eq(4)
      expect(result.pace).to eq(3)
      expect(result.time.strftime("%B%e, %Y")).to eq("June 5, 2015")
    end

    it "deletes posts" do
      post = @post_objs[1]
      db.delete_post(post.id)
      expect(db.get_post(post.id)).to eq(nil)
    end

    it "filters posts by age preference" do
      result = db.posts_filter_age(3)
      result.count.should eql(2)
      result[1].age_pref.should eql(3)
    end

    it "filters posts by gender preference" do
      result = db.posts_filter_gender(0)
      result.count.should eql(2)
      result[1].gender_pref.should eql(0)
    end

    it "filters posts by location and search radius" do
      result = db.posts_filter_location(44,55, 10)
      result.count.should eql(1)
      expect(result.map &:notes).to include("Let's go.")
    end

    it "filters posts by pace" do
      result = db.posts_filter_pace(2)
      result.count.should eql(1)
      result[0].notes.should eql("Sunny day run!")
    end

    it "filters posts by time" do
      result = db.posts_filter_time(@t_apr_first, @t_july_first)
      result.count.should eql(2)
      expect(result.map &:notes).to include("Let's go.", "Will be a fairly relaxed jog.")
    end

  end


  # POSTS AND CIRCLES
  describe "Post and Circle Interactions" do
    before :each do
      users = [
          {first_name: "Fast Feet", gender: 1, email:"marathons@speed.com", bday:"02/08/1987"},
          {first_name: "Runna Lot", gender: 2, email:"jogger@run.com", bday:"06/06/1966"},
          {first_name: "Jon Jones", gender: 2, email:"runlikemad@sprinter.com", bday:"03/14/1988"},
          {first_name: "Nee Upp", gender: 1, email:"sofast@runna.com", bday: "05/15/1994"}
      ]
      @user_objs = []
      users.each do |info|
          @user_objs << db.create_user(info)
      end

      @circle = db.create_circle({name: "MakerSquare", admin_id: @user_objs[0].id, max_members: 30})

      @t_apr_first = Time.parse("Apr 1 2014")
      @t_may_first = Time.parse("May 1 2014")
      @t_june_first = Time.parse("June 1 2014")
      @t_july_first = Time.parse("July 1 2014")

      posts = [
        {creator_id: @user_objs[0].id, time: @t_apr_first, latitude: 40, longitude: 51, pace: 2, notes:"Sunny day run!", complete:false, min_amt:10.50, age_pref: 0, gender_pref: 0},
        {creator_id: @user_objs[1].id, time: @t_may_first, latitude: 44, longitude: 55, pace: 1, notes:"Let's go.", complete:false, min_amt:5.50, age_pref: 3, gender_pref: 1},
        {creator_id: @user_objs[2].id, time: @t_june_first, latitude: 66, longitude: 77, pace: 7, notes:"Will be a fairly relaxed jog.", complete:true, min_amt:12.00, age_pref: 3, gender_pref: 1},
        {creator_id: @user_objs[3].id, time: @t_july_first, latitude: 88, longitude: 99, pace: 0, complete:false, min_amt:20.00, age_pref: 4, gender_pref: 0, circle_id: @circle.id},
      ]

      @post_objs = []
      posts.each do |attrs|
        @post_objs << db.create_post(attrs)
      end

    end

    it "creates a post associated with a circle" do
      post = @post_objs[3]
      circleID = post.circle_id
      expect((db.get_circle(circleID)).name).to eq("MakerSquare")
      expect((db.get_circle(circleID)).max_members).to eq(30)
    end

    it "gets all posts associated with a circle" do
      post_arr = db.get_circle_posts(@circle.id)
      expect(post_arr.count).to eq(1)
      expect(post_arr[0].age_pref).to eq(4)
    end

  end


  # POSTS AND COMMITMENTS
  describe "Post and Commitment interactions" do
    before :each do
      users = [
          {first_name: "FastFeet", gender: 1, email:"marathons@speed.com", bday:"02/08/1987"},
          {first_name: "RunnaLot", gender: 2, email:"jogger@run.com", bday:"06/06/1966"},
          {first_name: "JonJones", gender: 2, email:"runlikemad@sprinter.com", bday:"03/14/1988"},
          {first_name: "NeeUpp", gender: 1, email:"sofast@runna.com", bday: "05/15/1994"}
      ]
      @user_objs = []
      users.each do |info|
          @user_objs << db.create_user(info)
      end


      @t_apr_first = Time.parse("Apr 1 2014")
      @t_may_first = Time.parse("May 1 2014")
      @t_june_first = Time.parse("June 1 2014")
      @t_july_first = Time.parse("July 1 2014")

      posts = [
        {creator_id: @user_objs[0].id, time: @t_apr_first, latitude: 40, longitude: 51, pace: 2, notes:"Sunny day run!", complete:false, min_amt:10.50, age_pref: 0, gender_pref: 0},
        {creator_id: @user_objs[1].id, time: @t_may_first, latitude: 44, longitude: 55, pace: 1, notes:"Let's go.", complete:false, min_amt:5.50, age_pref: 3, gender_pref: 1},
        {creator_id: @user_objs[2].id, time: @t_june_first, latitude: 66, longitude: 77, pace: 7, notes:"Will be a fairly relaxed jog.", complete:true, min_amt:12.00, age_pref: 3, gender_pref: 1},
        {creator_id: @user_objs[3].id, time: @t_july_first, latitude: 88, longitude: 99, pace: 0, complete:false, min_amt:20.00, age_pref: 4, gender_pref: 0},
      ]

      @post_objs = []
      posts.each do |attrs|
        @post_objs << db.create_post(attrs)
      end

      @commit1 = db.create_commit({user_id: @user_objs[0].id, post_id: @post_objs[0].id, amount: 20.30})
      @commit2 = db.create_commit({user_id: @user_objs[1].id, post_id: @post_objs[0].id, amount: 15.00, fulfilled: true})
    end

    it "gets all people committed to a run" do
      post = @post_objs[0]
      committers = db.get_committed_users(post.id)
      expect(committers.count).to eq(2)
      committer_arr = [db.get_user(committers[0]), db.get_user(committers[1])]
      expect(committer_arr.map &:first_name).to include("RunnaLot", "FastFeet")
    end

    it "gets all people who attended a run" do
      post = @post_objs[0]
      attendees = db.get_attendees(post.id)
      expect(attendees.count).to eq(1)
      expect(db.get_user(attendees[0]).first_name).to eq("RunnaLot")
    end

  end

# COMMITMENT TESTS
  describe 'Commitments' do
    before :each do
      users = [
          {first_name: "FastFeet", gender: 1, email:"marathons@speed.com", bday:"02/08/1987"},
          {first_name: "RunnaLot", gender: 2, email:"jogger@run.com", bday:"06/06/1966"}
      ]
      @user_objs = []
      users.each do |info|
          @user_objs << db.create_user(info)
      end

      posts = [
        {creator_id: @user_objs[0].id, time: Time.now, latitude: 22, longitude: 33, pace: 2, notes:"Sunny day run!", complete:false, min_amt:10.50, age_pref: 0, gender_pref: 0},
        {creator_id: @user_objs[1].id, time: Time.now, latitude: 44, longitude: 55, pace: 1, notes:"Let's go.", complete:false, min_amt:5.50, age_pref: 3, gender_pref: 1}
      ]

      @post_objs = []
      posts.each do |info|
        @post_objs << db.create_post(info)
      end

      @commit1 = db.create_commit({user_id: @user_objs[0].id, post_id: @post_objs[0].id, amount: 3})
      @commit2 = db.create_commit({user_id: @user_objs[1].id, post_id: @post_objs[1].id, amount: 5, fulfilled: true})
    end

    it "creates a commitment with fulfilled set to false" do
      expect(db.get_user(@commit1.user_id).first_name).to eq("FastFeet")
      expect(db.get_post(@commit1.post_id).pace).to eq(2)
      expect(@commit1.fulfilled).to eq(false)
    end

    it "gets a commitment" do
      commit = db.get_commit(@commit1.id)
      expect(commit.amount).to eq(3)
    end

    it "gets commitments by user_id" do
      commits_arr = db.get_commits_by_user(@user_objs[1].id)
      expect(commits_arr.count).to eq(1)
      expect(commits_arr[0].fulfilled).to eq(true)
      expect(commits_arr[0].amount).to eq(5)
    end

    it "updates a commitment" do
      commit = db.update_commit(@commit1.id, {amount: 10})
      expect(commit.amount).to eq(10)
    end
  end

# CIRCLE TESTS
  describe 'Circles' do

    before :each do
      users = [
        {first_name: "FastFeet", gender: 1, email:"marathons@speed.com", bday:"2/8/1987"},
        {first_name: "RunnaLot", gender: 2, email:"jogger@run.com", bday:"6/6/1966"},
        {first_name: "JonJones", gender: 2, email:"runlikemad@sprinter.com", bday:"3/14/1988"},
        {first_name: "NeeUpp", gender: 1, email:"sofast@runna.com", bday: "5/15/1994"}
      ]

    @user_objs = []
    users.each do |attrs|
        @user_objs << db.create_user(attrs)
    end

    @circle1 = db.create_circle({name: "Silvercar", admin_id: @user_objs[1].id, max_members: 14, latitude: 32, longitude: 44})
    @circle2 = db.create_circle({name: "Crazy Apps", admin_id: @user_objs[2].id, max_members: 19, latitude: 22, longitude: 67})

    posts = [
      {creator_id: @user_objs[0].id, time: Time.now, latitude: 22, longitude: 33, pace: 2, notes:"Sunny day run!", complete:false, min_amt:10.50, age_pref: 0, gender_pref: 0, circle_id: nil},
      {creator_id: @user_objs[1].id, time: Time.now, latitude: 44, longitude: 55, pace: 1, notes:"Let's go.", complete:false, min_amt:5.50, age_pref: 3, gender_pref: 1, circle_id: nil},
      {creator_id: @user_objs[2].id, time: Time.now, latitude: 66, longitude: 77, pace: 7, notes:"Will be a fairly relaxed jog.", complete:true, min_amt:12.00, age_pref: 3, gender_pref: 1, circle_id: nil},
      {creator_id: @user_objs[3].id, time: Time.now, latitude: 88, longitude: 99, pace: 0, complete:false, min_amt:20.00, age_pref: 4, gender_pref: 0, circle_id: @circle1.id},
    ]

    @post_objs = []
    posts.each do |info|
      @post_objs << db.create_post(info)
    end

  end

    it "creates a circle" do
      expect(@circle1.name).to eq("Silvercar")
      expect(@circle1.max_members).to eq(14)
      expect(db.get_user(@circle1.admin_id).first_name).to eq("RunnaLot")
    end

    it "gets a circle" do
      circle = db.get_circle(@circle2.id)
      expect(circle.name).to eq("Crazy Apps")
    end

    it "gets the names of all circles" do
      name_hash = db.get_circle_names
      expect(name_hash.length).to eq(2)
      expect(name_hash["Silvercar"]).to eq(true)
      expect(name_hash["Crazy Apps"]).to eq(true)
    end

    it "gets all circles" do
      circles = db.all_circles
      expect(circles.count).to eq(2)
      expect(circles.map &:max_members).to include(14, 19)
    end

    it "filters circles by location and search radius" do
      result = db.circles_filter_location(32, 44, 10)
      result.count.should eql(1)
      expect(result.map &:name).to include("Silvercar")
    end

    it "updates a circle" do
      updated = db.update_circle(@circle1.id, {name:"Runner's World", max_members: 35})
      expect(updated.name).to eq("Runner's World")
      expect(updated.max_members).to eq(35)
    end

    it "adds a user to a circle" do
      result = db.add_users_to_circle(@circle1.id, [@user_objs[0].id])
      expect(result.member_ids.count).to eq(2)
      members = result.member_ids
      member_arr = [db.get_user(members[0]), db.get_user(members[1])]
      expect(member_arr.map &:first_name).to include("RunnaLot", "FastFeet")
    end

    it "filters out full circles" do
      full_circle = db.create_circle({name: "ATX Runners", admin_id: @user_objs[1].id, max_members: 3, latitude: 32, longitude: 44})
      db.add_users_to_circle(full_circle.id, [@user_objs[0].id, @user_objs[2].id])
      result = db.circles_filter_full
      expect(result.count).to eq(2)
    end
  end

# WALLET TESTS
  describe 'Wallets' do

    before :each do
        @user = db.create_user({first_name: "UsainBolt", gender: 2, email:"usain@sprinter.com", bday:"02/21/1985"})
        @wallet = db.create_wallet({user_id: @user.id, balance: 20.00})
    end

    it "creates a wallet" do
        expect(db.get_user(@wallet.user_id).first_name).to eq("UsainBolt")
    end

    it "gets a wallet by user id" do
        result = db.get_wallet_by_userid(@user.id)
        expect(result.balance).to eq(20.00)
    end

    it "updates a wallet's balance" do
      updated = db.update_wallet_balance(@user.id, 30.00)
      expect(db.get_user(updated.user_id).first_name).to eq("UsainBolt")
      expect(updated.balance).to eq(50.00)
    end

    it "deletes a wallet" do
        db.delete_wallet(@user.id)
        result = db.get_wallet_by_userid(@user.id)
        result.should be_nil
    end
  end

  # CHALLENGE TESTS
  describe 'Challenge' do
    before :each do
      users = [
        {username: "Fast Feet", gender: 1, email:"marathons@speed.com", password:"abc123", bday:"2/8/1987"},
        {username: "Runna Lot", gender: 2, email:"jogger@run.com", password:"111222", bday:"6/6/1966"}
      ]

    @user_objs = []
    users.each do |attrs|
      @user_objs << db.create_user(attrs)
    end

    @circle1 = db.create_circle({name: "MakerSquare", admin_id: @user_objs[0].id, max_members: 30})
    @circle2 = db.create_circle({name: "Hack Reactor", admin_id: @user_objs[1].id, max_members: 25})
    @challenge = db.create_challenge({name: "Monday Funday", sender_id: @circle1.id, recipient_id: @circle2.id, creator_id: @circle1.admin_id, time: Time.now, latitude:22, longitude: 33, pace: 1, notes:"Doom!", complete:false, min_amt:0, age_pref: 0, gender_pref: 0, circle_id: @circle1.id})
    end

    xit "creates a challenge with accepted set to default of false" do
    expect(@challenge.name).to eq("Monday Funday")
    expect(db.get_post(@challenge.post_id).notes).to eq("Doom!")
    end

    xit "gets a challenge" do
      challenge = db.get_challenge(@challenge.id)
      expect(challenge.name).to eq("Monday Funday")
    end

    xit "updates a challenge" do
    # add time tests
      updated = db.update_challenge(@challenge.id, {name:"Go HAM", latitude: 33, longitude: 44})
      expect(updated.name).to eq("Go HAM")
      expect(db.get_post(updated.post_id).latitude).to eq(33)
    end

    xit "deletes a challenge" do
      db.delete_challenge(@challenge.id)
      expect(db.get_challenge(@challenge.id)).to eq(nil)
    end

    xit "gets a challenge by sender or recipient ids" do
      result = db.get_circle_sent_challenges(@circle1.id)
      expect(result[0].name).to eq("Monday Funday")
      result = db.get_circle_rec_challenges(@circle2.id)
      expect(result[0].name).to eq("Monday Funday")
    end
  end

end

