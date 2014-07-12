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
    @db_class ||= Database::InMemory
    @__db_instance ||= @db_class.new(@env || 'test')
    # config = YAML.load_file File.join(File.dirname(__FILE__), "../db/config.yml")
    # @__db__ ||= RunPal::Database::ORM.new(config[ENV['DB_ENV']])
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
        {first_name: "RondaRousey", gender: 1, email:"jogger@run.com", bday:"06/06/1966"},
        {first_name: "LizCarmouche", gender: 1, email:"marine@military.com", bday: "05/15/1998"},
        {first_name: "JuliannaPena", gender: 1, email:"punch@fast.com", bday: "02/22/1944"},
        {first_name: "LailaAli", gender: 2, email:"sofast@runner.com", bday: "05/25/1994"},
        {first_name: "DanielCormier", gender: 2, email:"wrestle@elite.com", bday: "09/03/1979"},
        {first_name: "JonJones", gender: 2, email:"marathons@speed.com", bday:"02/08/1987", level: 0},
        {first_name: "CubSwanson", gender: 2, email:"runlikemad@sprinter.com", bday:"03/14/1988"},
        {first_name: "CainVelasquez", gender: 2, email:"sprint@runna.com", bday: "05/25/1994"}
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
      {name: "Silvercar", admin_id: users[0].id, max_members: 14, latitude: 32, longitude: 44},
      {name: "MakerSquare", admin_id: users[1].id, max_members: 19, latitude: 22, longitude: 67},
      {name: "ThoughtWorks", admin_id: users[2].id, max_members: 30, latitude: 98.882, longitude: -89.7},
      {name: "ThoughtBot", admin_id: users[3].id, max_members: 5, latitude: 12.1092, longitude: 34.7},
      {name: "DevMynd", admin_id: users[4].id, max_members: 10, latitude: 2.09, longitude: 99.81233},
      {name: "Kabam", admin_id: users[5].id, max_members: 12, latitude: 12.52, longitude: 67.002},
      {name: "Big Astronaut", admin_id: users[6].id, max_members: 60, latitude: 22, longitude: 67},
      {name: "8th Light", admin_id: users[7].id, max_members: 40, latitude: 22.009, longitude: 67},
      {name: "NerdWallet", admin_id: users[0].id, max_members: 30, latitude: 45.44, longitude: -55},
      {name: "Crowdtilt", admin_id: users[1].id, max_members: 6, latitude: 12.2, longitude: -7.88}
    ]

    circles = []
    circles_attrs.each do |attrs|
        circles << self.db.create_circle(attrs)
    end

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
      {user_id: users[6].id, circle_id: circles[9].id}
    ]

    join_reqs = []
    join_reqs_attrs.each do |attrs|
        join_reqs << self.db.create_join_req(attrs)
    end

    t_apr_first = DateTime.parse("Apr 1 2014 6:30am")
    t_may_first = DateTime.parse("May 1 2014 7:40pm")
    t_june_first = DateTime.parse("June 1 2014 12pm")
    t_july_first = DateTime.parse("July 1 2014 5:45pm")

    posts_attrs = [
        {creator_id: users[0].id, time: t_apr_first, max_runners: 4, latitude: 40, longitude: 51, pace: -1, notes:"Sunny day run!", min_amt:10.50, age_pref: 0, gender_pref: 0, min_distance: 4, address: "123 Main Street, Everytown, IL, USA"},
        {creator_id: users[1].id, time: t_may_first, max_runners: 6, latitude: 41.88331, longitude: -87.8001, pace: 0, notes:"Let's go.", min_amt:5.50, age_pref: 1, gender_pref: 1, min_distance: 5, address: "333 Washington Avenue, San Diego, CA, USA"},
        {creator_id: users[2].id, time: t_june_first, max_runners: 8, latitude: 44.0002, longitude: -55.0002, pace: 1, notes:"Will be a fairly relaxed jog.", min_amt:12.00, age_pref: 2, gender_pref: 1, min_distance: 1, address: "123 San Utopos, Everytown, WA, USA"},
        {creator_id: users[3].id, time: t_july_first, max_runners: 10, latitude: 41.8833, longitude: -87.80, pace: 2, min_amt:20.00, age_pref: 3, gender_pref: 0, min_distance: 7, address: "444 Main Street, Everytown, CO, USA"},
        {creator_id: users[4].id, time: t_apr_first, max_runners: 12, latitude: 64.0002, longitude: 90.0002, pace: 3, notes:"So much freakin' fun.", min_amt:12.00, age_pref: 4, gender_pref: 0, min_distance: 1, address: "13 Klay Street, Everytown, OH, USA"},
        {creator_id: users[5].id, time: t_may_first, max_runners: 5, latitude: 41.8833, longitude: -87.7802, pace: 4, notes:"We shall run until our eyes bleed.", min_amt:12.00, age_pref: 5, gender_pref: 2, min_distance: 1, address: "113 Main Street, Everytown, IA, USA"},
        {creator_id: users[6].id, time: t_june_first, max_runners: 7, latitude: 84.0002, longitude: 48.0002, pace: 5, notes:"Warm day!", min_amt:29.00, age_pref: 6, gender_pref: 0, min_distance: 2, address: "123 Major Road, Everytown, CO, USA"},
        {creator_id: users[7].id, time: t_july_first, max_runners: 9, latitude: -21.0002, longitude: -43.0002, pace: 6, notes:"Running is super cool", min_amt:12.00, age_pref: 7, gender_pref: 2, min_distance: 3, address: "93 Main Lane, Everytown, GA, USA"},
        {creator_id: users[0].id, time: t_apr_first, max_runners: 11, latitude: 88.0002, longitude: 93.0002, pace: 7, notes:"Let's run.", min_amt:30.00, age_pref: 8, gender_pref: 1, min_distance: 1, address: "3 Main Street, Townsville, TX, USA"},
        {creator_id: users[0].id, time: t_may_first, max_runners: 4, latitude: -40.0002, longitude: -21.0002, pace: 0, notes:"Aw, yisssssss.", min_amt:3.00, age_pref: 0, gender_pref: 0, min_distance: 10, address: "2 Madison Boulevard, Placeburg, CT, USA"},
        {creator_id: users[2].id, time: t_june_first, max_runners: 6, latitude: 10.0002, longitude: 12.0002, pace: 0, notes:"Then we shall beer o'clock.", min_amt:55.00, age_pref: 1, gender_pref: 1, min_distance: 5, address: "707 Main Street, Whereton, MA, USA"},
        {creator_id: users[5].id, time: t_july_first, max_runners: 8, latitude: -55.0002, longitude: 39.0002, pace: 1, notes:"LOL, wut?.", min_amt:12.00, age_pref: 2, gender_pref: 2, min_distance: 4, address: "631 Imaginary Road, Silicon Grove, CA, USA"}
      ]

    posts = []
    posts_attrs.each do |attrs|
        posts << self.db.create_post(attrs)
    end

    commits_attrs = [
      {user_id: users[0].id, post_id: posts[0].id, amount: 100.30},
      {user_id: users[1].id, post_id: posts[1].id, amount: 100.30},
      {user_id: users[2].id, post_id: posts[2].id, amount: 100.30},
      {user_id: users[3].id, post_id: posts[3].id, amount: 100.30},
      {user_id: users[4].id, post_id: posts[4].id, amount: 100.30},
      {user_id: users[5].id, post_id: posts[5].id, amount: 100.30},
      {user_id: users[6].id, post_id: posts[6].id, amount: 100.30},
      {user_id: users[7].id, post_id: posts[7].id, amount: 100.30},
      {user_id: users[0].id, post_id: posts[8].id, amount: 100.30},
      {user_id: users[1].id, post_id: posts[9].id, amount: 100.30},
      {user_id: users[2].id, post_id: posts[10].id, amount: 100.30},
      {user_id: users[3].id, post_id: posts[11].id, amount: 100.30},
      {user_id: users[1].id, post_id: posts[0].id, amount: 100.30},
      {user_id: users[2].id, post_id: posts[0].id, amount: 100.30},
      {user_id: users[3].id, post_id: posts[0].id, amount: 100.30}
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



