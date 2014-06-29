module RunPal
  class UpdateChallenge < UseCase

    def run(inputs)
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil
      inputs[:challenge_id] = inputs[:challenge_id] ? inputs[:challenge_id].to_i : nil

      challenge = RunPal.db.get_challenge(inputs[:challenge_id])
      return failure (:challenge_does_not_exist) if challenge.nil?

      circle = RunPal.db.get_circle(challenge.sender_id)
      return failure(:user_not_authorized) if inputs[:user_id] != circle.admin_id

      updated_challenge = update_challenge(inputs)
      success :challenge => updated_challenge
    end

    def update_challenge(attrs)
      RunPal.db.update_challenge(attrs[:challenge_id], attrs)
    end

  end
end
