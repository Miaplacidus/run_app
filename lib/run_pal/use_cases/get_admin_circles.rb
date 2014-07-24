module RunPal
  class GetAdminCircles < UseCase
    def run(inputs)
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      circles = RunPal.db.get_admin_circles(inputs[:user_id])

      success :circles => circles
    end
  end
end
