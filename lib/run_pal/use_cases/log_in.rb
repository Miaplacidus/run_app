module RunPal
  class LogIn < UseCase
    def run(inputs)

      auth = inputs[:auth]
      auth.delete(:provider)
      user = RunPal.db.create_from_omniauth(auth)

      return failure (:inputs_required) if user.nil?

      new_session = create_new_session(user_id: user.id)

      success :session_key => new_session.session_key, :user => user
    end

    def create_new_session(attrs)
      RunPal.db.create_session(attrs)
    end


  end
end
