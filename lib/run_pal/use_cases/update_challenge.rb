module RunPal
  class UpdateChallenge < UseCase

    def run(inputs)
      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:challenge_id] = inputs[:challenge_id].to_i

      inputs[:latitude] = inputs[:latitude].to_f if inputs[:latitude]
      inputs[:longitude] = inputs[:longitude].to_f if inputs[:longitude]
      inputs[:pace] = inputs[:pace].to_i if inputs[:pace]
      inputs[:min_amt] = inputs[:min_amt].to_f if inputs[:min_amt]
      inputs[:min_distance] = inputs[:min_distance].to_i if inputs[:min_distance]
      inputs[:age_pref] = inputs[:age_pref].to_i if inputs[:age_pref]
      inputs[:gender_pref] = inputs[:gender_pref].to_i if inputs[:gender_pref]
      inputs[:max_runners] = inputs[:max_runners].to_i if inputs[:max_runners]

      challenge = RunPal.db.get_challenge(inputs[:circle_id])
      return failure (:circle_does_not_exist) if circle.nil?

      updated_circle = update_circle(inputs)
      success :circle => updated_circle
    end

    def update_challenge(attrs)
      RunPal.db.update_challenge(attrs)
    end

  end
end
