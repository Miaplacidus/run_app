module RunPal
  class ShowCircleChallenges < UseCase

    def run(inputs)

      inputs[:circle_id] = inputs[:circle_id] ? inputs[:circle_id].to_i : nil
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil

      circle = RunPal.db.get_circle(inputs[:circle_id])
      return failure (:circle_does_not_exist) if circle.nil?

      user = RunPal.db.get_user(inputs[:user_id])
      return failure (:user_does_not_exist) if user.nil?

      rec_challenges = rec_challenges(inputs)
      sent_challenges = sent_challenges(inputs)
      rec_posts = []
      sent_posts = []
      membership = RunPal.db.is_member?(inputs[:user_id], inputs[:circle_id])

       if circle.admin_id == inputs[:user_id] || membership
        rec_challenges.each do |challenge|
          rec_posts << RunPal.db.get_post(challenge.post_id)
        end

        sent_challenges.each do |challenge|
          sent_posts << RunPal.db.get_post(challenge.post_id)
        end
      end

      success :rec_challenges => rec_challenges, :sent_challenges => sent_challenges, :rec_posts => rec_posts, :sent_posts => sent_posts
    end

    def rec_challenges(attrs)
      RunPal.db.get_circle_rec_challenges(attrs[:circle_id])
    end

    def sent_challenges(attrs)
      RunPal.db.get_circle_sent_challenges(attrs[:circle_id])
    end

  end
end
