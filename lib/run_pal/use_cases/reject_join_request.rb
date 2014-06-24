module RunPal
  class RejectJoinRequest < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:join_req_id] = inputs[:join_req_id].to_i

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      join_req = RunPal.db.get_join_req(inputs[:join_req_id])
      return failure(:request_does_not_exist) if join_req.nil?

      circle = RunPal.db.get_circle(join_req.circle_id)
      return failure(:circle_does_not_exist) if circle.nil?
      return failure (:user_not_authorized) if inputs[:user_id] != circle.admin_id

      reject_join_req(inputs)

      deleted_req = RunPal.db.get_join_req(inputs[:join_req_id])
      return failure(:failed_to_delete) if !deleted_req.nil?

      success :deleted_req => join_req
    end

    def reject_join_req(attrs)
      RunPal.db.delete_join_req(attrs[:join_req_id])
    end

  end
end
