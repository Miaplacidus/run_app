module RunPal
  class DeletePost < UseCase

    def run(inputs)
      inputs[:post_id] = inputs[:post_id] ? inputs[:post_id].to_i : nil
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil

      post = RunPal.db.get_post(inputs[:post_id])
      return failure(:post_does_not_exist) if post.nil?
      return failure(:user_not_authorized) if inputs[:user_id] != post.creator_id

      delete_post(inputs)
      deleted = RunPal.db.get_post(inputs[:post_id])
      return failure(:failed_to_delete) if !deleted.nil?

      success :post => post
    end

    def delete_post(attrs)
      RunPal.db.delete_post(attrs[:post_id])
    end

  end
end

