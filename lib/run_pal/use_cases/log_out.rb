module RunPal
  class LogOut < UseCase
    def run(inputs)

      user = RunPal.db.get_user_by_fbid(inputs[:fbid])
      return failure (:user_does_not_exist) if user.nil?

      delete_session(inputs)

      success :user => user
    end

    def delete_session(attrs)
      RunPal.db.destroy_session(attrs[:session_key])
    end


  end
end
