module RunPal
  class CreateJoinReq < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:circle_id] = inputs[:circle_id].to_i

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      circle = RunPal.db.get_circle(inputs[:circle_id])
      return failure(:circle_does_not_exist) if circle.nil?

      join_req = create_new_request(inputs)
      return failure(:invalid_inputs) if !join_req.valid?

      success :join_req => join_req
    end

    def create_new_request(attrs)
      RunPal.db.create_join_req({user_id: attrs[:user_id], circle_id: attrs[:circle_id]})
    end

  end
end
