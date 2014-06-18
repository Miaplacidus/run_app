module RunPal
  class DeletePost < UseCase

    def run(inputs)

      inputs[:creator_id] = inputs[:creator_id].to_i
      inputs[:pace] = inputs[:pace].to_i
      inputs[:time] = inputs[:time].to_i
      inputs[:min_distance] = inputs[:min_distance].to_i
      inputs[:age_pref] = inputs[:age_pref].to_i
      inputs[:gender_pref] = inputs[:gender_pref].to_i
      inputs[:max_runners] = inputs[:max_runners].to_i
      inputs[:min_amt] = inputs[:min_amt].to_f

      post = RunPal.db.get_post(inputs[:id])
      return failure(:post_does_not_exist) if post.nil?

      delete_post(inputs[:id])
      deleted = RunPal.db.get_post(inputs[:id])
      return failure(:failed_to_delete) if !deleted.nil?

      success :post => post
    end

    def delete_post(attrs)
      RunPal.db.delete_post(attrs)
    end

  end
end

