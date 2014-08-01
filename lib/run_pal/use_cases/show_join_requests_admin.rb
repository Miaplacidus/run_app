module RunPal
  class ShowJoinRequestsAdmin < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil
      inputs[:circle_id] = inputs[:circle_id] ? inputs[:circle_id].to_i : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      circle = RunPal.db.get_circle(inputs[:circle_id])
      return failure(:circle_does_not_exist) if circle.nil?

      join_req_arr = []
      users = []

      if (circle.admin_id == user.id)
        join_req_arr = get_join_requests_admin(inputs)
        users = get_reqs_user_list(inputs)
      end

      success :join_reqs => join_req_arr, :users => users
    end

    def get_join_requests_admin(attrs)
      RunPal.db.get_circle_join_req(attrs[:circle_id])
    end

    def get_reqs_user_list(attrs)
      RunPal.db.get_circle_join_reqs_users(attrs[:circle_id])
    end

  end
end
