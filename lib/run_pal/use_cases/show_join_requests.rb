module RunPal
  class ShowJoinRequests < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      join_req_arr = get_join_requests(inputs)

      success :join_reqs => join_req_arr
    end

    def get_join_requests(attrs)
      RunPal.db.get_user_join_req(attrs[:user_id])
    end

  end
end
