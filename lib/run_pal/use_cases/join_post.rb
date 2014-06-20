module RunPal
  class JoinPost < UseCase

    def run(inputs)

      inputs[:id] = inputs[:id].to_i
      inputs[:user_gender] = inputs[:user_gender].to_i
      inputs[:post_id] = inputs[:post_id].to_i
      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:amount] = inputs[:amount].to_f

      user = RunPal.db.get_user(inputs[:user_id])
      return failure (:user_does_not_exist) if user.nil?

      post = RunPal.db.get_post(inputs[:id])
      return failure (:post_does_not_exist) if !post
      return failure (:gender_incorrect) if gender < 1 || gender > 2
      return failure (:user_gender_disallowed) if inputs[:user_gender] != post.gender_pref && post.gender_pref != 0

      circle = post.circle_id
      if circle
        membership = RunPal.db.is_member?(inputs[:user_id])
        return failure (:circle_membership_required) if !membership
      end

      commit = create_new_commit(inputs)
      success :post => post, :commit => commit
    end

    def create_new_commit(attrs)
      RunPal.db.create_commit({post_id: attrs[:post_id], user_id: attrs[:user_id], amount: attrs[:amount]})
    end

  end
end
