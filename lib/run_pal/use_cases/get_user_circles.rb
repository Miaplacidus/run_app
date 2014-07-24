module RunPal
  class GetUserCircles < UseCase
    def run(inputs)
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      posts = RunPal.db.get_user_circles(inputs[:user_id])

      success :posts => posts
    end
  end
end
