require 'dotenv'
require 'active_model'
require 'active_record'
require 'active_record_tasks'
require 'pry-debugger'
require 'yaml'
require 'time'
require 'geocoder'
require 'omniauth-facebook'
require 'haversine'

Dotenv.load

module RunPal
  def self.db
    # @db_class ||= Database::InMemory
    @db_class ||= Database::ORM
    @__db_instance ||= @db_class.new(@env || 'test')
  end

  def self.db_class=(db_class)
    @db_class = db_class
  end

  def self.env=(env_name)
    @env = env_name
  end

  def self.db_seed
    self.db.clear_everything
    # ADD SEED INFORMATION HERE

    users_attrs = [
        {first_name: "RondaRousey", gender: 1, email:"jogger@run.com", bday:"06/06/1966", rating: 50 , level: 1 },
        {first_name: "LizCarmouche", gender: 1, email:"marine@military.com", bday: "05/15/1990", rating: 93, level: 2.8},
        {first_name: "JuliannaPena", gender: 1, email:"punch@fast.com", bday: "02/22/1944", rating: 98, level: 3.3},
        {first_name: "LailaAli", gender: 2, email:"sofast@runner.com", bday: "05/25/1984", rating: 42, level: 4.1},
        {first_name: "DanielCormier", gender: 2, email:"wrestle@elite.com", bday: "09/03/1979", rating: 33, level: 5.5},
        {first_name: "JonJones", gender: 2, email:"marathons@speed.com", bday:"02/08/1987", rating: 75, level: 6.7 },
        {first_name: "CubSwanson", gender: 2, email:"runlikemad@sprinter.com", bday:"03/14/1988", rating: 59, level: 7.1},
        {first_name: "CainVelasquez", gender: 2, email:"sprint@runna.com", bday: "05/25/1991", rating: 90, level: 8.4}
      ]

    users = []
    users_attrs.each do |attrs|
        users << self.db.create_user(attrs)
    end

    wallets_attrs = [
        {user_id: users[0].id, balance: 20.00},
        {user_id: users[1].id, balance: 40.00},
        {user_id: users[2].id, balance: 60.00},
        {user_id: users[3].id, balance: 80.00},
        {user_id: users[4].id, balance: 100.00},
        {user_id: users[5].id, balance: 120.00},
        {user_id: users[6].id, balance: 140.00}
      ]

    wallets = []
    wallets_attrs.each do |attrs|
        wallets << self.db.create_wallet(attrs)
    end


    circles_attrs = [
      {name: "Silvercar", admin_id: users[0].id, level: 0, max_members: 14, latitude: 32, longitude: 44, city: "Austin, TX, USA"},
      {name: "MakerSquare", admin_id: users[1].id, level: 1, max_members: 19, latitude: 22, longitude: 67, city: "Austin, TX, USA"},
      {name: "ThoughtWorks", admin_id: users[2].id, level: 2, max_members: 30, latitude: 41.883, longitude: -87.8, city: "Oak Park, IL, USA"},
      {name: "ThoughtBot", admin_id: users[3].id, level: 3, max_members: 5, latitude: 41.883, longitude: -87.8, city: "Oak Park, IL, USA"},
      {name: "DevMynd", admin_id: users[4].id, level: 4, max_members: 10, latitude: 41.8819, longitude: -87.6278, city: "Chicago, IL, USA"},
      {name: "Kabam", admin_id: users[5].id, level: 5, max_members: 12, latitude: 12.52, longitude: 67.002, city:"Tianjin"},
      {name: "Big Astronaut", admin_id: users[6].id, level: 6, max_members: 60, latitude: 22, longitude: 67, city:"Zhuhai"},
      {name: "8th Light", admin_id: users[7].id, level: 7, max_members: 40, latitude: 22.009, longitude: 67, city: "Xianggang"},
      {name: "NerdWallet", admin_id: users[0].id, level: 8, max_members: 30, latitude: 45.44, longitude: -55, city:"Shanghai"},
      {name: "Crowdtilt", admin_id: users[1].id, level: 0, max_members: 6, latitude: 12.2, longitude: -7.88, city:"Rio de Janeiro"}
    ]

    circles = []
    circles_attrs.each do |attrs|
        circles << self.db.create_circle(attrs)
    end

    # Adding members to circles:
    self.db.add_user_to_circle(3,9)
    self.db.add_user_to_circle(4,9)
    self.db.add_user_to_circle(5,9)

    # Creating a circle
    self.db.create_circle({name: "Oak Park Sprint", admin_id: 9, level: 0, max_members: 12, latitude: 41.883, longitude: -87.8, city:"Oak Park, IL, USA"})

    challenges_attrs = [
      {name: "Monday Funday", sender_id: circles[0].id, recipient_id: circles[1].id},
      {name: "Destroy", sender_id: circles[1].id, recipient_id: circles[2].id},
      {name: "DEMOLISH", sender_id: circles[2].id, recipient_id: circles[3].id},
      {name: "Kick ass!", sender_id: circles[3].id, recipient_id: circles[4].id},
      {name: "Run over!", sender_id: circles[4].id, recipient_id: circles[5].id},
      {name: "Hulk, SMASH!", sender_id: circles[5].id, recipient_id: circles[6].id},
      {name: "We're sleepy", sender_id: circles[6].id, recipient_id: circles[1].id},
      {name: "Meh", sender_id: circles[1].id, recipient_id: circles[3].id},
      {name: "Massacre!", sender_id: circles[2].id, recipient_id: circles[4].id},
      {name: "We hate running", sender_id: circles[3].id, recipient_id: circles[5].id},
      {name: "We really hate running", sender_id: circles[4].id, recipient_id: circles[6].id}
    ]


    challenges = []
    challenges_attrs.each do |attrs|
        challenges << self.db.create_challenge(attrs)
    end

    join_reqs_attrs = [
      {user_id: users[0].id, circle_id: circles[0].id},
      {user_id: users[1].id, circle_id: circles[0].id},
      {user_id: users[2].id, circle_id: circles[0].id},
      {user_id: users[3].id, circle_id: circles[1].id},
      {user_id: users[4].id, circle_id: circles[2].id},
      {user_id: users[5].id, circle_id: circles[3].id},
      {user_id: users[6].id, circle_id: circles[4].id},
      {user_id: users[1].id, circle_id: circles[4].id},
      {user_id: users[2].id, circle_id: circles[5].id},
      {user_id: users[3].id, circle_id: circles[6].id},
      {user_id: users[4].id, circle_id: circles[7].id},
      {user_id: users[5].id, circle_id: circles[8].id},
      {user_id: users[6].id, circle_id: circles[9].id},
      {user_id: users[6].id, circle_id: 11 }
    ]

    join_reqs = []
    join_reqs_attrs.each do |attrs|
        join_reqs << self.db.create_join_req(attrs)
    end

    t_apr_first = Time.parse("Apr 1 2014 6:30am")
    t_may_first = Time.parse("May 1 2014 7:40pm")
    t_june_first = Time.parse("June 1 2014 12pm")
    t_july_sxt = Time.parse("July 16 2014 5:45pm")
    t_july_svt = Time.parse("July 17 2014 3:00pm")
    t_aug_twn = Time.parse("August 20 2014 5:30pm")

    posts_attrs = [
        {creator_id: users[0].id, time: t_apr_first, max_runners: 4, latitude: 40, longitude: 51, pace: -1, notes:"Sunny day run!", min_amt:10.50, age_pref: 0, gender_pref: 0, min_distance: 4, address: "123 Main Street, Everytown, IL, USA"},
        {creator_id: users[1].id, time: t_aug_twn, max_runners: 6, latitude: 41.8833, longitude: -87.8001, pace: 0, notes:"Let's go.", min_amt:5.50, age_pref: 2, gender_pref: 1, min_distance: 5, address: "333 Washington Avenue, San Diego, CA, USA"},
        {creator_id: users[2].id, time: t_june_first, max_runners: 8, latitude: 44.0002, longitude: -55.0002, pace: 1, notes:"Will be a fairly relaxed jog.", min_amt:12.00, age_pref: 2, gender_pref: 1, min_distance: 1, address: "123 San Utopos, Everytown, WA, USA", circle_id: 3},
        {creator_id: users[3].id, time: t_july_sxt, max_runners: 10, latitude: 41.8833, longitude: -87.80, pace: 2, min_amt:20.00, age_pref: 3, gender_pref: 0, min_distance: 7, address: "444 Main Street, Everytown, CO, USA"},
        {creator_id: users[4].id, time: t_apr_first, max_runners: 12, latitude: 64.0002, longitude: 90.0002, pace: 3, notes:"So much freakin' fun.", min_amt:12.00, age_pref: 4, gender_pref: 0, min_distance: 1, address: "13 Klay Street, Everytown, OH, USA"},
        {creator_id: users[5].id, time: t_may_first, max_runners: 5, latitude: 41.8833, longitude: -87.7802, pace: 4, notes:"We shall run until our eyes bleed.", min_amt:12.00, age_pref: 5, gender_pref: 2, min_distance: 1, address: "113 Main Street, Everytown, IA, USA"},
        {creator_id: users[6].id, time: t_june_first, max_runners: 7, latitude: 84.0002, longitude: 48.0002, pace: 5, notes:"Warm day!", min_amt:29.00, age_pref: 6, gender_pref: 0, min_distance: 2, address: "123 Major Road, Everytown, CO, USA"},
        {creator_id: users[7].id, time: t_july_svt, max_runners: 9, latitude: -21.0002, longitude: -43.0002, pace: 6, notes:"Running is super cool", min_amt:12.00, age_pref: 7, gender_pref: 2, min_distance: 3, address: "93 Main Lane, Everytown, GA, USA"},
        {creator_id: users[0].id, time: t_apr_first, max_runners: 11, latitude: 88.0002, longitude: 93.0002, pace: 7, notes:"Let's run.", min_amt:30.00, age_pref: 8, gender_pref: 1, min_distance: 1, address: "3 Main Street, Townsville, TX, USA"},
        {creator_id: users[0].id, time: t_may_first, max_runners: 4, latitude: -40.0002, longitude: -21.0002, pace: 0, notes:"Aw, yisssssss.", min_amt:3.00, age_pref: 0, gender_pref: 0, min_distance: 10, address: "2 Madison Boulevard, Placeburg, CT, USA"},
        {creator_id: users[2].id, time: t_june_first, max_runners: 6, latitude: 10.0002, longitude: 12.0002, pace: 0, notes:"Then we shall beer o'clock.", min_amt:55.00, age_pref: 1, gender_pref: 1, min_distance: 5, address: "707 Main Street, Whereton, MA, USA"},
        {creator_id: users[5].id, time: t_july_sxt, max_runners: 8, latitude: -55.0002, longitude: 39.0002, pace: 1, notes:"LOL, wut?.", min_amt:12.00, age_pref: 2, gender_pref: 2, min_distance: 4, address: "631 Imaginary Road, Silicon Grove, CA, USA"}
      ]

    posts = []
    posts_attrs.each do |attrs|
        posts << self.db.create_post(attrs)
    end

    # Circle-Associated Posts
    self.db.create_post({creator_id: 9, time: t_aug_twn, max_runners: 10, latitude: 41.8833, longitude: -87.80, pace: 2, min_amt:5.00, age_pref: 3, gender_pref: 0, min_distance: 7, address: "321 Mulberry Street, Gotown, IL, USA", circle_id: 11})
    self.db.create_post({creator_id: 9, time: t_aug_twn, max_runners: 5, latitude: 41.8833, longitude: -87.80, pace: 1, min_amt:10.00, age_pref: 0, gender_pref: 0, min_distance: 3, address: "555 Blueberry Street, Hometown, IL, USA", circle_id: 11})

    commits_attrs = [
      {user_id: users[1].id, post_id: posts[0].id, amount: 10.30},
      {user_id: users[2].id, post_id: posts[1].id, amount: 10.30},
      {user_id: users[3].id, post_id: posts[2].id, amount: 10.30},
      {user_id: users[4].id, post_id: posts[3].id, amount: 10.30},
      {user_id: users[5].id, post_id: posts[4].id, amount: 10.30},
      {user_id: users[6].id, post_id: posts[5].id, amount: 10.30},
      {user_id: users[7].id, post_id: posts[6].id, amount: 10.30},
      {user_id: users[0].id, post_id: posts[7].id, amount: 10.30},
      {user_id: users[1].id, post_id: posts[8].id, amount: 10.30},
      {user_id: users[2].id, post_id: posts[9].id, amount: 10.30},
      {user_id: users[3].id, post_id: posts[10].id, amount: 10.30},
      {user_id: users[4].id, post_id: posts[11].id, amount: 10.30},
      {user_id: users[5].id, post_id: posts[0].id, amount: 10.30},
      {user_id: users[6].id, post_id: posts[0].id, amount: 10.30},
      {user_id: users[7].id, post_id: posts[0].id, amount: 10.30}
    ]

    commits = []
    commits_attrs.each do |attrs|
        commits << self.db.create_commit(attrs)
    end

  end
end

require_relative 'run_pal/entity.rb'
require_relative 'use_case.rb'

Dir["#{File.dirname(__FILE__)}/run_pal/database/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/run_pal/entities/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/run_pal/use_cases/*.rb"].each { |f| require(f) }



