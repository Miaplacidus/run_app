module RunPal
  class DeleteChallenge < UseCase

    def run(inputs)
      inputs[:challenge_id] = inputs[:challenge_id] ? inputs[:challenge_id].to_i : nil
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil

      challenge = RunPal.db.get_challenge(inputs[:challenge_id])
      return failure(:challenge_does_not_exist) if challenge.nil?

      circle = RunPal.db.get_circle(challenge.sender_id)
      return failure(:circle_does_not_exist) if circle.nil?

      return failure (:user_not_authorized) if inputs[:user_id] != circle.admin_id

      delete_challenge(inputs)

      deleted = RunPal.db.get_challenge(inputs[:challenge_id])
      return failure(:failed_to_delete_challenge) if !deleted.nil?

      success :challenge => challenge
    end

    def delete_challenge(attrs)
      RunPal.db.delete_challenge(attrs[:challenge_id])
    end

  end
end
