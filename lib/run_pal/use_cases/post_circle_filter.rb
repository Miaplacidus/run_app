module RunPal
  class FilterPostsByCircle < UseCase

    def run(inputs)
      # CIRCLE_ID, USER_GENDER
      inputs[:circle_id] = inputs[:circle_id] ? inputs[:circle_id].to_i : nil
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure (:user_does_not_exist) if user.nil?
      inputs[:user_gender] = user.gender

      circle = RunPal.db.get_circle(inputs[:circle_id])
      return failure(:circle_does_not_exist) if circle.nil?

      post_arr = filter_posts_by_circle(inputs)

      success :post_arr => post_arr
    end

    def filter_posts_by_circle(attrs)
      RunPal.db.get_circle_posts(attrs[:circle_id], attrs[:user_gender])
    end

  end
end
