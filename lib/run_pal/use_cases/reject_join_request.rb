module RunPal
  class RejectJoinRequest < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil
      inputs[:circle_id] = inputs[:circle_id] ? inputs[:circle_id].to_i : nil
      inputs[:admin_id] = inputs[:admin_id] ? inputs[:admin_id].to_i : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      circle = RunPal.db.get_circle(inputs[:circle_id])
      return failure(:circle_does_not_exist) if circle.nil?
      return failure (:user_not_authorized) if inputs[:admin_id] != circle.admin_id

      join_req = RunPal.db.get_user_circle_join_req(inputs[:user_id], inputs[:circle_id])
      return failure(:request_does_not_exist) if join_req.nil?

      reject_join_req(join_req.id)

      deleted_req = RunPal.db.get_join_req(join_req.id)
      return failure(:failed_to_delete) if !deleted_req.nil?

      success :deleted_req => join_req
    end

    def reject_join_req(join_req_id)
      RunPal.db.delete_join_req(join_req_id)
    end

  end
end
