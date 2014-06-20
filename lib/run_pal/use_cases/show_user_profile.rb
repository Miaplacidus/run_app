module RunPal
  class ShowUserProfile < UseCase

    def run(inputs)
      inputs[:user_id] = inputs[:user_id].to_i

      user = RunPal.db.get_user(inputs[:id])
      return failure(:user_does_not_exist) if user.nil?

      user = get_user_profile(inputs)
      success :user => user
    end

    def get_user_profile(attrs)
      RunPal.db.get_user(attrs[:id])
    end

  end
end
