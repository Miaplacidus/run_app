module RunPal
  class DeleteJoinReq < UseCase

    def run(inputs)

      inputs[:join_req_id] = inputs[:join_req_id].to_i

      join_req = RunPal.db.get_join_req(inputs[:join_req_id])
      return failure(:request_does_not_exist) if join_req.nil?

      delete_join_request(inputs[:join_req_id])
      deleted = RunPal.db.get_join_req(inputs[:join_req_id])
      return failure(:failed_to_delete) if !deleted.nil?

      success :join_req => join_req
    end

    def delete_join_request(attrs)
      RunPal.db.delete_join_req(attrs)
    end

  end
end

