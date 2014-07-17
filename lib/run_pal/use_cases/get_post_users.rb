module RunPal
  class GetPostUsers < UseCase
    def run(inputs)
      inputs[:post_id] = inputs[:post_id] ? inputs[:post_id].to_i : nil

      users = RunPal.db.get_committed_users(inputs[:post_id])

      success :users => users
    end
  end

end
