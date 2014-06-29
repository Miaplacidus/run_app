module RunPal
  class ShowPost < UseCase
    def run(inputs)
      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:post_id] = inputs[:post_id].to_i

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      post = RunPal.db.get_post(inputs[:post_id])
      return failure(:post_does_not_exist) if post.nil?
      return failure(:cannot_view_opposite_gender_posts) if user.gender != post.gender_pref && post.gender_pref != 0

      user_objs = []
      runner = RunPal.db.has_committed(post.id, user.id)

      if runner
        committed_user_ids = RunPal.db.get_committed_users(post.id)
        committed_users = committed_user_ids.each do |user_id|
          user_objs << RunPal.db.get_user(user_id)
        end
      end

      post = get_post_data(inputs)
      success :post => post, :users => user_objs
    end

    def get_post_data(attrs)
      RunPal.db.get_post(attrs[:post_id])
    end

  end
end
