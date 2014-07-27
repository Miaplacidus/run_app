module RunPal
  class GetUser < UseCase
    def run(inputs)
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      age_group = RunPal.db.get_user_age(inputs[:user_id])

      success :user => user, :age_group => age_group
    end
  end
end
