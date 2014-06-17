module RunPal
  class CreatePost < UseCase

    def run(inputs)
      user = RunPal.db.get_user(inputs[:creator_id].to_i)
      return failure (:user_does_not_exist) if user.nil?

      puts inputs

      # inputs[:creator_id] = inputs[:creator_id].to_i
      inputs[:pace] = inputs[:pace].to_i
      inputs[:time] = inputs[:time].to_i
      inputs[:location] = inputs[:location].to_s
      inputs[:min_distance] = inputs[:min_distance].to_i
      inputs[:age_pref] = inputs[:age_pref].to_i
      inputs[:gender_pref] = inputs[:gender_pref].to_i
      inputs[:max_runners] = inputs[:max_runners].to_i
      # inputs[:circle_id] = inputs[:circle_id].to_i if inputs[:circle_id]
      # inputs[:min_amt] = inputs[:min_amt].to_f

      post = create_new_post(inputs)
      return failure(:invalid_input) if !post.valid?

      success :post => post
    end

    def create_new_post(attrs)
      binding.pry
      RunPal.db.create_post(attrs)
    end

  end
end
