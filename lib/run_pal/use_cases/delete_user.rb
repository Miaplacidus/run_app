module RunPal
  class DeleteUser < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      delete_account(inputs)
      deleted = RunPal.db.get_user(inputs[:user_id])
      return failure(:failed_to_delete) if !deleted.nil?

      success :user => user
    end

    def delete_account(attrs)
      RunPal.db.delete_user(attrs[:user_id])
    end

  end
end

