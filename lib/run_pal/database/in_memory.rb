module RunPal
  module Database
    class InMemory

      def initialize(config=nil)
        clear_everything
      end

      def clear_everything
        @challenge_id_counter = 0
        @circle_id_counter = 0
        @commit_id_counter = 0
        @join_req_counter = 0
        @post_id_counter = 0
        @session_id_counter = 0
        @user_id_counter = 0
        @wallet_id_counter = 0
        @challenges = {} #Key: challenge_id, Value: challenge_obj_attrs hash
        @circles = {} # Key: circle_id, Value: circle_obj_attrs hash
        @commits = {} # Key: commit_id, Value: commit_obj_attrs hash
        @join_reqs = {} # Key: join_req_id, Value: join_req_obj_attrs hash
        @posts = {} # Key: post_id, Value: post_obj_attrs hash
        @sessions = {} # Key: session_key, Value: user_id
        @users = {} # Key: user_id, Value: user_obj_attrs hash
        @wallets = {} # Key: wallet_id, Value: wallet_obj_attrs hash
      end

      def create_challenge(attrs)
        id = @challenge_id_counter+=1
        attrs[:id] = id
        attrs[:state] = 'pending'
        attrs[:notes] ||= ''
        @challenges[id] = attrs
        RunPal::Challenge.new(attrs)
      end

      def get_challenge(id)
        challenge = @challenges[id] ? RunPal::Challenge.new(@challenges[id]) : nil
      end

      def get_circle_rec_challenges(circle_id)
        filtered_challenges = @challenges.values.select{|attrs| attrs[:recipient_id] == circle_id}
        filtered_challenges_objs = filtered_challenges.map{|attrs| RunPal::Challenge.new(attrs)}
      end

      def get_circle_sent_challenges(circle_id)
        filtered_challenges = @challenges.values.select{|attrs| attrs[:sender_id] == circle_id}
        filtered_challenges_objs = filtered_challenges.map{|attrs| RunPal::Challenge.new(attrs)}
      end

      def update_challenge(id, attrs)
        challenge_attrs = @challenges[id]
        challenge_attrs.merge!(attrs)
        RunPal::Challenge.new(challenge_attrs)
      end

      def delete_challenge(id)
        @challenges.delete(id)
      end

      def create_circle(attrs)
        id = @circle_id_counter+=1
        attrs[:id] = id
        attrs[:member_ids] = [attrs[:admin_id]]
        @circles[id] = attrs
        RunPal::Circle.new(attrs)
      end

      def get_circle(id)
        circle = @circles[id] ? RunPal::Circle.new(@circles[id]) : nil
      end

      def get_circle_names
        name_hash = {}
        @circles.values.map{ |attrs| name_hash[attrs[:name]] = true}
        name_hash
      end

      def all_circles
        @circles.values.map {|attrs| RunPal::Circle.new(attrs)}
      end

      def circles_filter_location(user_lat, user_long, radius)
        filtered_circles = @circles.values.select{|attrs|
          distance = Haversine.distance(user_lat, user_long, attrs[:latitude], attrs[:longitude])
          distance.to_mi <= radius
        }

        filtered_circles_objs = filtered_circles.map {|attrs| RunPal::Circle.new(attrs)}
      end

      def circles_filter_full(filters)
        # {user_lat, user_long, radius}
        loc_filtered_circles = @circles.values.select{|attrs|
          distance = Haversine.distance(filters[:user_lat], filters[:user_long], attrs[:latitude], attrs[:longitude])
          distance.to_mi <= filters[:radius]
        }

        filtered_circles = loc_filtered_circles.select{|attrs| attrs[:member_ids].length < attrs[:max_members]}
        filtered_circles_objs = filtered_circles.map{|attrs| RunPal::Circle.new(attrs)}
      end

      def update_circle(id, attrs)
        circle_attrs = @circles[id]
        circle_attrs.merge!(attrs)
        RunPal::Circle.new(circle_attrs)
      end

      def add_users_to_circle(id, user_arr)
        circle_attrs = @circles[id]
        circle_attrs[:member_ids] += user_arr
        RunPal::Circle.new(circle_attrs)
      end

      def is_member?(user_id, circle_id)
        return nil if !@circles[circle_id]
        circle = @circles[circle_id]
        membership = circle[:member_ids].detect {|i| i == user_id}
        membership != nil
      end

      def create_commit(attrs)
        id = @commit_id_counter+=1
        attrs[:id] = id
        attrs[:fulfilled] = false
        @commits[id] = attrs
        RunPal::Commitment.new(attrs)
      end

      def get_commit(id)
        @commits[id] ? RunPal::Commitment.new(@commits[id]) : nil
      end

      def get_commits_by_user(user_id)
        commits = @commits.values.select {|attrs| attrs[:user_id] == user_id }
        commits.map {|attrs| RunPal::Commitment.new(attrs) }
      end

      def update_commit(id, attrs)
        commit_attrs = @commits[id]
        commit_attrs.merge!(attrs)
        RunPal::Commitment.new(commit_attrs)
      end

      def delete_commit(id)
        @commits.delete(id)
      end

      def create_join_req(attrs)
        id = @join_req_counter+=1
        attrs[:id] = id
        attrs[:accepted] = false
        @join_reqs[id] = attrs
        RunPal::JoinRequest.new(attrs)
      end

      def get_join_req(id)
        join_req = @join_reqs[id] ? RunPal::JoinRequest.new(@join_reqs[id]) : nil
      end

      def get_user_join_req(user_id)
        @join_reqs.values.select{|attrs| attrs[:user_id] == user_id}
      end

      def get_circle_join_req(circle_id)
        @join_reqs.values.select{|attrs| attrs[:circle_id] == circle_id}
      end

      def all_join_reqs
        @join_reqs.values.map {|attrs| RunPal::JoinRequest.new(attrs)}
      end

      def approve_req(id)
        join_req_attrs = @join_reqs[id]
        join_req_attrs[:accepted] = true
        RunPal::JoinRequest.new(join_req_attrs)
      end

      def delete_join_req(id)
        @join_reqs.delete(id)
      end

      def create_post(attrs)
        id = @post_id_counter+=1
        attrs[:id] = id
        attrs[:notes] ||= ""
        attrs[:circle_id] ||= nil

        @posts[id] = attrs
        RunPal::Post.new(attrs)
      end

      def get_post(id)
        post = @posts[id] ? RunPal::Post.new(@posts[id]) : nil
      end

      def get_circle_posts(circle_id, user_gender)
        post_attributes = @posts.values.select {|post_attrs| post_attrs[:circle_id] == circle_id}
        gender_filtered = post_attributes.select{|post_attrs| post_attrs[:gender_pref] == user_gender || post_attrs[:gender_pref] == 0 }

        post_objs = gender_filtered.map {|attrs| RunPal::Post.new(attrs)}
      end

      def all_posts
        @posts.values.map {|attrs| RunPal::Post.new(attrs)}
      end

      def get_committed_users(post_id)
        post_commits = @commits.values.select {|attrs| attrs[:post_id] == post_id}
        committed_user_ids = post_commits.map {|attrs| attrs[:user_id]}
      end

      def get_attendees(post_id)
        post_commits = @commits.values.select {|attrs| attrs[:post_id] == post_id && attrs[:fulfilled] == true}
        attendee_ids = post_commits.map {|attrs| attrs[:user_id]}
      end

      def update_post(id, attrs)
        post_attrs = @posts[id]
        post_attrs.merge!(attrs)
        RunPal::Post.new(post_attrs)
      end

      def delete_post(id)
        @posts.delete(id)
      end

      def posts_filter_age(age, filters)
        # filters = {user_lat, user_long, radius, gender_pref, user_gender}
        loc_filter_posts = posts_limit_loc_gender(filters)

        filtered_posts = loc_filter_posts.select {|attrs| attrs[:age_pref] == age}
        filtered_posts_objs = filtered_posts.map {|attrs| RunPal::Post.new(attrs)}
      end

      def posts_filter_gender(filters)
         # filters = {user_lat, user_long, radius, gender_pref, user_gender}
        loc_filter_posts = posts_limit_loc_gender(filters)
        filtered_posts = loc_filter_posts.map {|attrs| RunPal::Post.new(attrs)}
      end

      def posts_filter_location(user_lat, user_long, radius)
        filtered_posts = @posts.values.select{|attrs|
          distance = Haversine.distance(user_lat, user_long, attrs[:latitude], attrs[:longitude])
          distance.to_mi <= radius
        }

        filtered_posts_objs = filtered_posts.map {|attrs| RunPal::Post.new(attrs)}
      end

      def posts_limit_loc_gender(filters)
        # filters = {user_lat, user_long, radius, gender_pref, user_gender}
        filtered_posts = []

        loc_filtered_posts = @posts.values.select{|attrs|
          distance = Haversine.distance(filters[:user_lat], filters[:user_long], attrs[:latitude], attrs[:longitude])
          distance.to_mi <= filters[:radius]
        }

        if filters[:gender_pref] == 3
          filtered_posts = loc_filtered_posts.select{|attrs|
            attrs[:gender_pref] == 0 || attrs[:gender_pref] == filters[:user_gender]
          }
        else
          filtered_posts = loc_filtered_posts.select{|attrs| attrs[:gender_pref] == filters[:gender_pref]}
        end

        filtered_posts
      end

      def posts_filter_pace(pace, filters)
        # filters = {user_lat, user_long, radius, gender_pref, user_gender}
        loc_filter_posts = posts_limit_loc_gender(filters)

        filtered_posts = loc_filter_posts.select {|attrs| attrs[:pace] == pace}
        filtered_posts_objs = filtered_posts.map {|attrs| RunPal::Post.new(attrs)}
      end

      def posts_filter_time(start_time, end_time, filters)
        # filters = {user_lat, user_long, radius, gender_pref, user_gender}
        loc_filter_posts = posts_limit_loc_gender(filters)

        filtered_posts = loc_filter_posts.select {|attrs| attrs[:time] > start_time && attrs[:time] < end_time}
        filtered_posts_objs = filtered_posts.map {|attrs| RunPal::Post.new(attrs)}
      end

      def has_committed(post_id, user_id)
        commit_attrs = @commits.detect{|key, attrs| attrs[:user_id] == user_id && attrs[:post_id] == post_id}
        commit_attrs ? RunPal::Commitment.new(commit_attrs[1]) : nil
      end

      def user_nearby?(attrs)
        distance = Haversine.distance(attrs[:user_lat], attrs[:user_long], attrs[:post_lat], attrs[:post_long])
        if distance.to_mi <= 1
          return true
        else
          return false
        end
      end

      def create_user(attrs)
        id = @user_id_counter+=1
        attrs[:id] = id
        @users[id] = attrs
        RunPal::User.new(attrs)
      end

      def get_user(id)
        @users[id] ? RunPal::User.new(@users[id]) : nil
      end

      def get_user_by_email(email)
        user_attributes = @users.values.find {|user_attrs| user_attrs[:email] == email}
        return nil if user_attributes.nil?
        RunPal::User.new(user_attributes)
      end

      def all_users
        @users.values.map {|attrs| RunPal::User.new(attrs)}
      end

      def update_user(user_id, attrs)
        user_attrs = @users[user_id]
        user_attrs.merge!(attrs)
        RunPal::User.new(user_attrs)
      end

      def delete_user(id)
        @users.delete(id)
      end

      def from_omniauth(auth)
        gender = 0
        if auth.extra.raw_info.gender == 'female'
          gender = 1
        elsif auth.extra.raw_info.gender == 'male'
          gender = 2
        end

        user_attrs_arr = @users.values
        retrieved_user = user_attrs_arr.select{|attr_hash| attr_hash[:fbid] == auth.uid}
        user = retrieved_user[0]

        if user == nil
          user = create_user({first_name: auth.info.first_name, email: auth.info.email, gender: gender, bday: auth.extra.raw_info.birthday, fbid: auth.uid, oauth_token: auth.credentials.token, oauth_expiry: Time.at(auth.credentials.expires_at), img_url: auth.info.image})
        else
          user = update_user(user[:id], {first_name: auth.info.first_name, email: auth.info.email, gender: gender, bday: auth.extra.raw_info.birthday, fbid: auth.uid, oauth_token: auth.credentials.token, oauth_expiry: Time.at(auth.credentials.expires_at), img_url: auth.info.image})
        end

        user
      end

      def create_wallet(attrs)
        id = @wallet_id_counter+=1
        attrs[:id] = id

        if !attrs[:balance]
          attrs[:balance] = 0
        end

        @wallets[id] = attrs
        RunPal::Wallet.new(attrs)
      end

      def get_wallet_by_userid(user_id)
        wallet_attributes = @wallets.values.find {|wallet_attrs| wallet_attrs[:user_id] == user_id}
        return nil if wallet_attributes.nil?
        RunPal::Wallet.new(wallet_attributes)
      end

      def update_wallet_balance(user_id, transaction)
        wallet_attributes = @wallets.values.find {|wallet_attrs| wallet_attrs[:user_id] == user_id}
        return nil if wallet_attributes.nil?
        wallet_attributes[:balance] += transaction
        RunPal::Wallet.new(wallet_attributes)
      end

      def delete_wallet(user_id)
        @wallets.delete(user_id)
      end

    end

  end
end
