module RunPal
  class ShowUserWallet < UseCase

    def run(inputs)
      inputs[:user_id] = inputs[:user_id].to_i

      user = RunPal.db.get_user(inputs[:user_id])
      return failure(:user_does_not_exist) if user.nil?

      wallet = RunPal.db.get_wallet_by_userid(inputs[:user_id])
      return failure(:wallet_does_not_exist) if wallet.nil?

      success :wallet => wallet
    end

  end
end
