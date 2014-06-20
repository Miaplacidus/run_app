module RunPal
  class UpdateChallenge < UseCase

    def run(inputs)
      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:challenge_id] = inputs[:challenge_id].to_i

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
