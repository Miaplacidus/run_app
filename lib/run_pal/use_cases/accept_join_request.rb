module RunPal
  class AcceptJoinRequest < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil
      inputs[:join_req_id] = inputs[:join_req_id] ? inputs[:join_req_id].to_i : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      join_req = RunPal.db.get_join_req(inputs[:join_req_id])
      return failure(:request_does_not_exist) if join_req.nil?

      circle = RunPal.db.get_circle(join_req.circle_id)
      return failure(:circle_does_not_exist) if circle.nil?
      return failure (:circle_full) if circle.member_ids.length == circle.max_members

      return failure (:user_not_authorized) if inputs[:user_id] != circle.admin_id

      join_req = accept_join_req(inputs)

      new_user = RunPal.db.get_user(join_req.user_id)
      return failure(:new_user_does_not_exist) if new_user.nil?

      inputs[:new_user_id] = new_user.id
      inputs[:circle_id] = circle.id

      updated_circle = new_circle_member(inputs)

      success :circle => updated_circle, :user => new_user
    end

    def accept_join_req(attrs)
      RunPal.db.approve_req(attrs[:join_req_id])
    end

    def new_circle_member(attrs)
      RunPal.db.add_users_to_circle(attrs[:circle_id],[attrs[:new_user_id]])
    end

  end
end
