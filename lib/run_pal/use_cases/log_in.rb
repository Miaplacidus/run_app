module RunPal
  class LogIn < UseCase
    def run(inputs)

      user = log_in(inputs[:auth])
      return failure(:inputs_required) if user.nil?

      success :user => user
    end

    def log_in(auth)
      RunPal.db.from_omniauth(auth)
    end


  end
end
