module RunPal
  class AcceptChallenge < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:admin_id].to_i
      inputs[:admin_id] = inputs[:admin_id].to_i
      inputs[:recipient_id] = inputs[:recipient_id].to_i
      inputs[:challenge_id] = inputs[:challenge_id].to_i

      recipient = RunPal.db.get_circle(inputs[:recipient_id])
      return failure (:circle_does_not_exist) if recipient.nil?

      challenge = RunPal.db.get_challenge(inputs[:challenge_id])
      return failure(:challenge_does_not_exist) if challenge.nil?

      return failure (:user_not_authorized) if inputs[:user_id] != inputs[:admin_id]

      challenge = accept_challenge(inputs)
      return failure(:invalid_inputs) if !challenge.valid?

      success :challenge => challenge
    end

    def accept_challenge(attrs)
      RunPal.db.update_challenge(attrs[:challenge_id], {state: attrs[:state]})
    end

  end
end
