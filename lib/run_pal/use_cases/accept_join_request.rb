module RunPal
  class AcceptJoinRequest < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil
      inputs[:circle_id] = inputs[:circle_id] ? inputs[:circle_id].to_i : nil
      inputs[:admin_id] = inputs[:admin_id] ? inputs[:admin_id].to_i : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      join_req = RunPal.db.get_user_circle_join_req(inputs[:user_id], inputs[:circle_id])
      return failure(:request_does_not_exist) if join_req.nil?

      circle = RunPal.db.get_circle(join_req.circle_id)
      return failure(:circle_does_not_exist) if circle.nil?
      return failure (:circle_full) if circle.member_ids.length == circle.max_members

      return failure (:user_not_authorized) if inputs[:admin_id] != circle.admin_id

      join_req = accept_join_req(join_req.id)
      updated_circle = new_circle_member(inputs)

      success :circle => updated_circle, :user => user
    end

    def accept_join_req(join_req_id)
      RunPal.db.approve_req(join_req_id)
    end

    def new_circle_member(attrs)
      RunPal.db.add_users_to_circle(attrs[:circle_id],[attrs[:user_id]])
    end

  end
end
