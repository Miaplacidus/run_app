require 'time'

module RunPal
  class CheckIn < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil
      inputs[:user_lat] = inputs[:user_lat] ? inputs[:user_lat].to_f : nil
      inputs[:user_long] = inputs[:user_long] ? inputs[:user_long].to_f : nil
      inputs[:commit_id] = inputs[:commit_id] ? inputs[:commit_id].to_i : nil
      inputs[:post_id] = inputs[:post_id] ? inputs[:post_id].to_i : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      commit = RunPal.db.get_commit(inputs[:commit_id])
      return failure(:commit_does_not_exist) if commit.nil?
      return failure (:commit_does_not_belong_to_user) if inputs[:user_id] != commit.user_id

      post = RunPal.db.get_post(commit.post_id)
      return failure(:post_does_not_exist) if post.nil?

      seven_minutes = 420
      check_in_commit = nil
      user_nearby = nil

      if Time.now > post.time - seven_minutes && Time.now < post.time + seven_minutes
        user_nearby = RunPal.db.user_nearby?({user_lat: inputs[:user_lat], user_long: inputs[:user_long], post_lat: post.latitude, post_long: post.longitude})
        if user_nearby
          check_in_commit = check_in_user(inputs)
        end
      end

      success :commit => check_in_commit, :post => post
    end

    def check_in_user(attrs)
      RunPal.db.update_commit(attrs[:commit_id], {fulfilled: true})
    end

  end
end
