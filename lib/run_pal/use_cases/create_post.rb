module RunPal
  class CreatePost < UseCase

    def run(inputs)

      inputs[:creator_id] = inputs[:creator_id].to_i
      inputs[:pace] = inputs[:pace].to_i
      inputs[:time] = inputs[:time].to_i
      inputs[:min_distance] = inputs[:min_distance].to_i
      inputs[:age_pref] = inputs[:age_pref].to_i
      inputs[:gender_pref] = inputs[:gender_pref].to_i
      inputs[:max_runners] = inputs[:max_runners].to_i
      inputs[:min_amt] = inputs[:min_amt].to_f

      user = RunPal.db.get_user(inputs[:creator_id])
      return failure (:user_does_not_exist) if user.nil?

      post = create_new_post(inputs)
      return failure(:invalid_input) if !post.valid?

      success :post => post
    end

    def create_new_post(attrs)
      RunPal.db.create_post(attrs)
    end

  end
end
