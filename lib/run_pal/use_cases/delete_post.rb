module RunPal
  class DeletePost < UseCase

    def run(inputs)

      inputs[:post_id] = inputs[:post_id].to_i

      post = RunPal.db.get_post(inputs[:post_id])
      return failure(:post_does_not_exist) if post.nil?

      delete_post(inputs[:post_id])
      deleted = RunPal.db.get_post(inputs[:post_id])
      return failure(:failed_to_delete) if !deleted.nil?

      success :post => post
    end

    def delete_post(attrs)
      RunPal.db.delete_post(attrs)
    end

  end
end

