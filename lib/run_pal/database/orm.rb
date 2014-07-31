module RunPal

  module Database
    class ORM

       def initialize(env)
        ActiveRecord::Base.establish_connection(
          # YAML.load_file("db/config.yml")[env]
          YAML.load_file File.join(File.dirname(__FILE__), "../../db/config.yml")[env]
        )
      end

      def clear_everything
        Circle.destroy_all
        Challenge.destroy_all
        Commitment.destroy_all
        JoinRequest.destroy_all
        Post.destroy_all
        User.destroy_all
        Wallet.destroy_all
      end

      class Circle < ActiveRecord::Base
        # Differentiate between reg users and administrator
        belongs_to :admin, class_name:"User"

        has_many :circle_users
        has_many :users, :through => :circle_users

        has_many :posts

        has_many :join_requests

        has_many :sent_challenges, class_name: "Challenge", foreign_key:"sender_id"
        has_many :received_challenges, class_name: "Challenge", foreign_key:"recipient_id"
      end

      class Challenge < ActiveRecord::Base
        belongs_to :post

        # Differentiate between sender and recipient
        belongs_to :sender, class_name: "Circle", foreign_key: "sender_id"
        belongs_to :recipient, class_name: "Circle", foreign_key: "recipient_id"
      end

      class Commitment < ActiveRecord::Base
        belongs_to :post
        belongs_to :user
      end

      class JoinRequest < ActiveRecord::Base
        belongs_to :user
        belongs_to :circle
      end

      class User < ActiveRecord::Base
        has_many :adm_circles, class_name:"Circle"

        has_many :circle_users
        has_many :circles, :through => :circle_users

        has_many :commitments

        has_many :created_posts, class_name:"Posts", foreign_key:"creator_id"

        has_many :join_requests

        has_many :post_users
        has_many :posts, :through => :post_users

        has_one :wallet
      end

      class Wallet < ActiveRecord::Base
        belongs_to :user
      end

      class CircleUsers < ActiveRecord::Base
        belongs_to :circle
        belongs_to :user
      end

      class Post < ActiveRecord::Base
        has_many :commitments

        has_one :challenge
        # differentiate between creator and committers
        belongs_to :creator, class_name:"User", foreign_key:"creator_id"

        has_many :post_users
        has_many :users, :through => :post_users

        belongs_to :circle
      end

      class PostUsers < ActiveRecord::Base
        belongs_to :post
        belongs_to :user
      end

      def create_challenge(attrs)
        post_attrs = attrs.clone

        post_attrs.delete_if do |name, value|
          setter = "#{name}"
          !RunPal::Post.method_defined?(setter)
        end

        ar_post = Post.create(post_attrs)

        attrs.delete_if do |name, value|
          setter = "#{name}"
          !RunPal::Challenge.method_defined?(setter)
        end

        attrs.merge!({post_id: ar_post.id})
        ar_challenge = Challenge.create(attrs)
        RunPal::Challenge.new(ar_challenge.attributes)
      end

      def get_challenge(id)
        ar_challenge = Challenge.where(id: id).first
        return nil if ar_challenge == nil
        RunPal::Challenge.new(ar_challenge.attributes)
      end

      def get_circle_sent_challenges(circle_id)
        ar_circle = Circle.where(id: circle_id).first
        sent_chal = ar_circle.sent_challenges.order(:created_at)
      end

      def get_circle_rec_challenges(circle_id)
        ar_circle = Circle.where(id: circle_id).first
        received_chal = ar_circle.received_challenges.order(:created_at)
      end

      def update_challenge(id, attrs)
        post_attrs = attrs.clone

        post_attrs.delete_if do |name, value|
          setter = "#{name}"
          !RunPal::Post.method_defined?(setter)
        end

        ar_challenge = Challenge.where(id: id).first

        post_id = ar_challenge.post_id
        ar_post = Post.where(id: post_id).first
        ar_post.update_attributes(post_attrs)

        attrs.delete_if do |name, value|
          setter = "#{name}"
          !RunPal::Challenge.method_defined?(setter)
        end

        ar_challenge.update_attributes(attrs)

        updated_chal = Challenge.where(id: id).first
        RunPal::Challenge.new(updated_chal.attributes)
      end

      def delete_challenge(id)
        Challenge.where(id: id).first.delete
      end

      def create_circle(attrs)

        ar_circle = Circle.create(attrs)
        CircleUsers.create(circle_id: ar_circle.id, user_id: ar_circle.admin_id)

        attrs_w_members = ar_circle.attributes
        attrs_w_members[:member_ids] = [ar_circle.admin_id]

        RunPal::Circle.new(attrs_w_members)
      end

      def get_circle(id)
        ar_circle = Circle.where(id: id).first
        return nil if ar_circle == nil

        ar_members = CircleUsers.where(circle_id: ar_circle.id)
        members = []

        ar_members.each do |ar_member|
          members << ar_member.id
        end

        attrs_w_members = ar_circle.attributes
        attrs_w_members[:member_ids] = members
        RunPal::Circle.new(attrs_w_members)
      end

      def get_circle_names
        ar_circles = Circle.all
        name_hash = {}

        ar_circles.each do |ar_circle|
          name_hash[ar_circle.name] = true
        end

        name_hash
      end

      def get_user_circles(user_id)
        ar_circle_user = CircleUsers.where(user_id: user_id)
        circles = ar_circle_user.map do |membership|
          Circle.where(id: membership.circle_id).first
        end

        circles.map{|ar_circle| RunPal::Circle.new(ar_circle.attributes)}
      end

      def get_admin_circles(user_id)
        ar_admin_circles = Circle.all.select{|ar_circle| ar_circle.admin_id == user_id}
        ar_admin_circles.map{|ar_circle| RunPal::Circle.new(ar_circle.attributes)}
      end

      def all_circles
        Circle.all.map do |ar_circle|
          RunPal::Circle.new(ar_circle.attributes)
        end
      end

      def circles_filter_location(user_lat, user_long, radius)
        filtered_circles = Circle.all.select do |ar_circle|
          distance = Haversine.distance(user_lat, user_long, ar_circle.latitude, ar_circle.longitude)
          distance.to_mi <= radius
        end

        filtered_circles.map{|ar_circle| RunPal::Circle.new(ar_circle.attributes)}
      end

      def circles_filter_full(filters)
        # {user_lat, user_long, radius}
        loc_filtered_circles = Circle.all.select do |ar_circle|
          distance = Haversine.distance(filters[:user_lat], filters[:user_long], ar_circle.latitude, ar_circle.longitude)
          distance.to_mi <= filters[:radius]
        end

        filtered_circles = loc_filtered_circles.select do |ar_circle|
          num_members = CircleUsers.where(circle_id: ar_circle.id).length
          num_members < ar_circle.max_members
        end

        filtered_circles.map {|ar_circle| RunPal::Circle.new(ar_circle.attributes)}
      end

      def update_circle(id, attrs)
        Circle.where(id: id).first.update_attributes(attrs)
        updated_circle = Circle.where(id: id).first
        RunPal::Circle.new(updated_circle.attributes)
      end

      def add_user_to_circle(id, user_id)
        ar_circle_user = CircleUsers.create({circle_id: id, user_id: user_id})

        membership = CircleUsers.where(circle_id: id)
        member_ids = membership.map &:user_id
        ar_circle = Circle.where(id: id).first
        circle_attrs = ar_circle.attributes.clone

        circle_attrs.merge!(member_ids: member_ids)
        RunPal::Circle.new(circle_attrs)
      end

      def add_users_to_circle(id, user_ids)
        user_ids.each do |user_id|
          ar_circle_user = CircleUsers.create({circle_id: id, user_id: user_id})
        end

        membership = CircleUsers.where(circle_id: id)
        member_ids = membership.map &:user_id
        ar_circle = Circle.where(id: id).first
        circle_attrs = ar_circle.attributes.clone

        circle_attrs.merge!(member_ids: member_ids)
        RunPal::Circle.new(circle_attrs)
      end

      def is_member?(user_id, circle_id)
        return nil if Circle.where(id: circle_id).first.nil?
        membership = CircleUsers.where("circle_id = ? AND user_id = ?", circle_id, user_id).first
        membership != nil
      end

      def create_commit(attrs)
        ar_commit = Commitment.create(attrs)
        RunPal::Commitment.new(ar_commit.attributes)
      end

      def get_commit(id)
        ar_commit = Commitment.where(id: id).first
        return nil if ar_commit == nil
        RunPal::Commitment.new(ar_commit.attributes)
      end

      def get_user_commit(user_id, post_id)
        ar_commit = Commitment.where("user_id = ? AND post_id = ?", user_id, post_id).first
        return nil if ar_commit.nil?
        RunPal::Commitment.new(ar_commit.attributes)
      end

      def get_user_commits(user_id)
        ar_commits = Commitment.where(user_id: user_id)
        return nil if ar_commits.empty?
        ar_commits.map{|ar_commit| RunPal::Commitment.new(ar_commit.attributes)}
      end

      def update_commit(id, attrs)
        Commitment.where(id: id).first.update_attributes(attrs)
        updated_commit = Commitment.where(id: id).first
        RunPal::Commitment.new(updated_commit.attributes)
      end

      def delete_commit(id)
        Commitment.where(id: id).first.destroy
      end

      def create_join_req(attrs)
        ar_join_req = JoinRequest.create(attrs)
        RunPal::JoinRequest.new(ar_join_req.attributes)
      end

      def get_join_req(id)
        JoinRequest.where(id: id).first
      end

      def get_user_join_req(user_id)
        ar_join_reqs = JoinRequest.where(user_id: user_id)
        ar_join_reqs.map{|ar_join_req| RunPal::JoinRequest.new(ar_join_req.attributes)}
      end

      def get_circle_join_req(circle_id)
        ar_join_reqs = JoinRequest.where(circle_id: circle_id)
        ar_join_reqs.map{|ar_join_req| RunPal::JoinRequest.new(ar_join_req.attributes)}
      end

      def approve_req(id)
        ar_join_req = JoinRequest.where(id: id).first
        ar_join_req.accepted = true
        ar_join_req.save!
        RunPal::JoinRequest.new(ar_join_req.attributes)
      end

      def delete_join_req(id)
        JoinRequest.where(id: id).first.destroy
      end

      def create_post(attrs)
        commit_attrs = attrs.clone

        commit_attrs.delete_if do |name, value|
          setter = "#{name}"
          !RunPal::Commitment.method_defined?(setter)
        end

        ar_post = Post.create(attrs)
        pid = ar_post.id

        commit_attrs.merge!({post_id: pid, amount: 0, user_id: attrs[:creator_id]})
        create_commit(commit_attrs)

        RunPal::Post.new(ar_post.attributes)
      end

      def get_post(id)
        ar_post = Post.where(id: id).first
        return nil if ar_post == nil
        RunPal::Post.new(ar_post.attributes)
      end

      def get_circle_posts(circle_id)
        ar_circle = Circle.where(id: circle_id).first
        ar_circle.posts
      end

      def all_posts
        ar_posts = Post.all

        ar_posts.map do |ar_post|
          RunPal::Post.new(ar_post.attributes)
        end
      end

      def get_committed_users(post_id)
        ar_post = Post.where(id: post_id).first
        ar_commits = ar_post.commitments
        committed_user_ids = ar_commits.map &:user_id
        committed_user_ids.map {|user_id| get_user(user_id)}
      end

      def get_attendees(post_id)
        ar_post = Post.where(id: post_id).first
        ar_commits = ar_post.commitments.where(fulfilled: true)
        attendees = ar_commits.map &:user_id
        attendees.map{|user_id| get_user(user_id)}
      end

      def is_committed?(user_id, post_id)
        ar_commit = Commitment.where("user_id = ? AND post_id = ?", user_id, post_id).first
        return true if ar_commit
        return false
      end

      def get_user_posts(user_id)
        commits = get_user_commits(user_id)
        posts = commits.map do |commit|
          pid = commit.post_id
          get_post(pid)
        end

        one_hour = 3600
        filtered_posts = posts.select do |post|
          !(post.time < Time.now - one_hour)
        end
        filtered_posts
      end

      def get_admin_posts(user_id)
        ar_posts = Post.where(creator_id: user_id)
        one_hour = 3600

        filtered_posts = ar_posts.select do |ar_post|
          !(ar_post.time < Time.now - one_hour)
        end

        filtered_posts.map{|ar_post| RunPal::Post.new(ar_post.attributes)}
      end

      def update_post(id, attrs)
        Post.where(id: id).first.update_attributes(attrs)
        updated_post = Post.where(id: id).first
        RunPal::Post.new(updated_post.attributes)
      end

      def delete_post(id)
        Commitment.where(post_id: id).each do |ar_commit|
          ar_commit.destroy
        end
        Post.where(id: id).first.destroy
      end

      def posts_filter_age(age, filters)
        # filters = {user_lat, user_long, radius, gender_pref, user_gender}
        loc_gender_filtered_posts = posts_limit_loc_gender(filters)
        filtered_posts = loc_gender_filtered_posts.select{|ar_post| ar_post.age_pref == age}
        filtered_posts.map{|ar_post| RunPal::Post.new(ar_post.attributes)}
      end

      def posts_filter_gender(filters)
        # filters = {user_lat, user_long, radius, gender_pref, user_gender}
        loc_gender_filtered_posts = posts_limit_loc_gender(filters)
        loc_gender_filtered_posts.map do |ar_post|
          RunPal::Post.new(ar_post.attributes)
        end
      end

      def posts_filter_location(user_lat, user_long, radius)
        filtered_posts = Post.all.select do |ar_post|
          distance = Haversine.distance(user_lat, user_long, ar_post.latitude, ar_post.longitude)
          distance.to_mi <= radius
        end

        filtered_posts.map{|ar_post| RunPal::Post.new(ar_post.attributes)}
      end

      def posts_filter_pace(pace, filters)
        # filters = {user_lat, user_long, radius, gender_pref, user_gender}
        loc_gender_filtered_posts = posts_limit_loc_gender(filters)
        filtered_posts = loc_gender_filtered_posts.select{|ar_post| ar_post.pace == pace}
        filtered_posts.map{|ar_post| RunPal::Post.new(ar_post.attributes)}
      end

      def posts_filter_time(start_time, end_time, filters)
        # filters = {user_lat, user_long, radius, gender_pref, user_gender}
        loc_gender_filtered_posts = posts_limit_loc_gender(filters)
        filtered_posts = loc_gender_filtered_posts.select{|ar_post| ar_post.time > start_time && ar_post.time < end_time}
        filtered_posts.map{|ar_post| RunPal::Post.new(ar_post.attributes)}
      end

      def posts_limit_loc_gender(filters)
        # filters = {user_lat, user_long, radius, gender_pref, user_gender}
        filtered_posts = []

        loc_filtered_posts = Post.all.select do |ar_post|
          distance = Haversine.distance(filters[:user_lat], filters[:user_long], ar_post.latitude, ar_post.longitude)
          distance.to_mi <= filters[:radius]
        end

        if filters[:gender_pref] == 3
          filtered_posts = loc_filtered_posts.select do |ar_post|
            ar_post.gender_pref == 0 || ar_post.gender_pref == filters[:user_gender]
          end
        else
          filtered_posts = loc_filtered_posts.select do |ar_post|
            ar_post.gender_pref == filters[:gender_pref]
          end
        end

        filtered_posts
      end

      def has_committed(post_id, user_id)
        ar_commit = Commitment.where("user_id = ? AND post_id = ?", user_id, post_id).first
        ar_commit ? RunPal::Commitment.new(ar_commit.attributes) : nil
      end

      def user_nearby?(filters)
        #filters = {user_lat, user_long, :post_lat, post_long}
        distance = Haversine.distance(filters[:user_lat], filters[:user_long], filters[:post_lat], filters[:post_long])
        if distance.to_mi <= 1
          return true
        else
          return false
        end
      end


      def create_user(attrs)
        ar_user = User.create(attrs)
        RunPal::User.new(ar_user.attributes)
      end

      def from_omniauth(auth)
        User.where(fbid: auth.uid).first_or_initialize.tap do |user|
          # user.provider = auth.provider
          user.fbid = auth.uid
          user.first_name = auth.info.first_name
          user.oauth_token = auth.credentials.token
          user.oauth_expiry = Time.at(auth.credentials.expires_at)
          user.img_url = auth.info.image
          user.email = auth.info.email
          user.bday = auth.extra.raw_info.birthday

          fb_gender = auth.extra.raw_info.gender

          if fb_gender == 'female'
            user.gender = 1
          elsif fb_gender == 'male'
            user.gender = 2
          else
            user.gender = 0
          end

          user.save!
        end

        ar_user = User.where(fbid: auth.uid).first
        RunPal::User.new(ar_user.attributes)
      end

      def get_user(id)
        ar_user = User.where(id: id).first
        return nil if !ar_user
        RunPal::User.new(ar_user.attributes)
      end

      def get_user_age(id)
        ar_user = User.where(id: id).first
        return nil if !ar_user

        bday = ar_user.bday
        return nil if bday.nil?

        birthday = bday.split('/')
        birthday = DateTime.new(birthday[2].to_i, birthday[0].to_i, birthday[1].to_i)
        age = (DateTime.now - birthday) / 365.25

        case age
          when 18..23
            return 1
          when 23..30
            return 2
          when 30..40
            return 3
          when 40..50
            return 4
          when 50..60
            return 5
          when 60..70
            return 6
          when 70..80
            return 7
          when 80..110
            return 8
          else
            return nil
        end
      end

      def calculate_user_level(user_id)
        attended = Commitment.where("user_id = ? AND fulfilled = ?", user_id, true)
        return nil if attended.empty?
        att_posts = attended.map{|ar_commit| get_post(ar_commit.post_id)}
        paces = att_posts.map{|post| post.pace}
        sum = paces.inject{|memo, n| memo + n}
        average = sum/attended.length
        average.round
      end

      def calculate_user_rating(user_id)
        attended = Commitment.where("user_id = ? AND fulfilled = ?", user_id, true).length
        return nil if attended.empty?

        num_past_posts = 0
        Commitment.all.each do |ar_commit|
          post = get_post(ar_commit.post_id)
          if ar_commit.user_id == user_id && post.time < Time.now
            num_past_posts += 1
          end
        end

        return 0 if num_past_posts == 0
        rating = attended/num_past_posts*100
        rating.round
      end

      def get_user_by_fbid(fbid)
        ar_user = User.where(fbid: fbid).first
        return nil if !ar_user
        RunPal::User.new(ar_user.attributes)
      end

      def get_user_by_email(email)
        ar_user = User.where(email: email).first
        return nil if !ar_user
        RunPal::User.new(ar_user.attributes)
      end

      def all_users
        User.all.map do |ar_user|
          RunPal::User.new(ar_user.attributes)
        end
      end

      def update_user(user_id, attrs)
        User.where(id: user_id).first.update_attributes(attrs)
        updated_user = User.where(id: user_id).first
        RunPal::User.new(updated_user.attributes)
      end

      def delete_user(id)
        User.where(id: id).first.destroy
      end

      def create_wallet(attrs)
        ar_wallet = Wallet.create(attrs)
        RunPal::Wallet.new(ar_wallet.attributes)
      end

      def get_wallet_by_userid(user_id)
        ar_wallet = Wallet.where(user_id: user_id).first
        return nil if ar_wallet == nil
        RunPal::Wallet.new(ar_wallet.attributes)
      end

      def update_wallet_balance(user_id, transaction)
        ar_wallet = Wallet.where(user_id: user_id).first
        ar_balance = ar_wallet.balance
        updated_bal = ar_balance + transaction

        ar_wallet.update_attributes({balance: updated_bal})
        updated_wallet = Wallet.where(user_id: user_id).first

        RunPal::Wallet.new(updated_wallet.attributes)
      end

      def delete_wallet(user_id)
        ar_wallet = Wallet.where(user_id: user_id).first.delete
      end

    end
  end
end
