module RunPal
  class CheckIn < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:user_lat] = inputs[:user_lat].to_i
      inputs[:user_long] = inputs[:user_long].to_i
      inputs[:post_id] = inputs[:post_id].to_i

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      commits = RunPal.db.get_commits_by_user(user.id)
      return failure(:user_has_no_commits) if commits.nil?

      checkin_post = nil

      commits.each do |commit|
        ten_minutes = 600
        five_minutes = 300
        posts = RunPal.db.get_post(commit.post_id)
        if Time.now >= post.time + ten_minutes && Time.now <= post.time + five_minutes
          user_nearby = RunPal.db.user_nearby?({user_lat: inputs[:user_lat], user_long: inputs[:user_long], post_lat: post.latitude, post_long: post.longitude})
          if user_nearby
            check_in_user(inputs)
          end
        end
      end

      post = create_new_post(inputs)
      return failure(:invalid_input) if !post.valid?

      success :post => post
    end

    def check_in_user(attrs)
      RunPal.db.update_commit(attrs[:commit_id], {fulfilled: true})
    end

  end
end
