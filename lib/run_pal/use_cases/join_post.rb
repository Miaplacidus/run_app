module RunPal
  class JoinPost < UseCase

    def run(inputs)

      inputs[:post_id] = inputs[:post_id] ? inputs[:post_id].to_i : nil
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil
      inputs[:amount] = inputs[:amount] ? inputs[:amount].to_f : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure (:user_does_not_exist) if user.nil?

      post = RunPal.db.get_post(inputs[:post_id])
      return failure (:post_does_not_exist) if !post
      return failure (:user_gender_disallowed) if user.gender != post.gender_pref && post.gender_pref != 0

      return failure(:commit_amt_too_low) if inputs[:amount] < post.min_amt

      circle = post.circle_id
      if circle
        membership = RunPal.db.is_member?(inputs[:user_id])
        return failure (:circle_membership_required) if !membership
      end

      if !RunPal.db.is_committed?(inputs[:user_id], inputs[:post_id])
        commit = create_new_commit(inputs)
      else
        commit = RunPal.db.get_user_commit(inputs[:user_id], inputs[:post_id])
      end

      success :post => post, :commit => commit
    end

    def create_new_commit(attrs)
      RunPal.db.create_commit({post_id: attrs[:post_id], user_id: attrs[:user_id], amount: attrs[:amount]})
    end

  end
end
