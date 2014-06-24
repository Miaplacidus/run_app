module RunPal
  class AcceptChallenge < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:challenge_id] = inputs[:challenge_id].to_i

      challenge = RunPal.db.get_challenge(inputs[:challenge_id])
      return failure(:challenge_does_not_exist) if challenge.nil?

      recipient_id = challenge.recipient_id
      circle = RunPal.db.get_circle(recipient_id)
      return failure (:circle_does_not_exist) if recipient.nil?

      return failure (:user_not_authorized) if inputs[:user_id] != circle.admin_id
      return failure(:user_not_recipient) if challenge.recipient_id != circle.id

      challenge = accept_challenge(inputs)
      return failure(:failed_to_accept) if challenge.state != 'accepted'

      success :challenge => challenge
    end

    def accept_challenge(attrs)
      RunPal.db.update_challenge(attrs[:challenge_id], {state: attrs[:state]})
    end

  end
end
