module RunPal
  class CreateChallenge < UseCase

    def run(inputs)

      # Challenge-specific properties
      inputs[:sender_id] = inputs[:sender_id].to_i
      inputs[:recipient_id] = inputs[:recipient_id].to_i
      inputs[:user_id] = inputs[:user_id].to_i


      sender = RunPal.db.get_circle(inputs[:sender_id])
      return failure (:circle_does_not_exist) if sender.nil?

      return failure(:user_not_authorized) if sender.admin_id != inputs[:user_id]

      recipient = RunPal.db.get_circle(inputs[:recipient_id])
      return failure (:circle_does_not_exist) if recipient.nil?

      challenge = create_new_challenge(inputs)
      return failure(:invalid_inputs) if !challenge.valid?

      success :challenge => challenge

    end

    def create_new_challenge(attrs)
      RunPal.db.create_challenge(attrs)
    end

  end
end
