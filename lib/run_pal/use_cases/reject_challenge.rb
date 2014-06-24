module RunPal
  class RejectChallenge < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:challenge_id] = inputs[:challenge_id].to_i

      challenge = RunPal.db.get_challenge(inputs[:challenge_id])
      return failure(:challenge_does_not_exist) if challenge.nil?

      recipient_id = challenge.recipient_id
      circle = RunPal.db.get_circle(recipient_id)
      return failure(:circle_does_not_exist) if circle.nil?

      return failure(:user_not_authorized) if inputs[:user_id] != circle.admin_id
      return failure(:user_not_recipient) if challenge.recipient_id != circle.id

      chellenge = reject_challenge(inputs)
      return failure(:failed_to_reject) if challenge.state != 'rejected'

      success :challenge => challenge
    end

    def reject_challenge(attrs)
      RunPal.db.update_challenge(attrs[:challenge_id], {state: 'rejected'})
    end

  end
end
