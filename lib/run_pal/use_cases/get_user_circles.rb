module RunPal
  class GetUserCircles < UseCase
    def run(inputs)
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      circles = RunPal.db.get_user_circles(inputs[:user_id])

      success :circles => circles
    end
  end
end
