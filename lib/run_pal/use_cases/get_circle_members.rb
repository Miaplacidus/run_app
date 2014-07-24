module RunPal
  class GetCircleMembers < UseCase
    def run(inputs)
      inputs[:circle_id] = inputs[:post_id] ? inputs[:post_id].to_i : nil

      users = RunPal.db.get_circle_members(inputs[:circle_id])

      success :users => users
    end
  end

end
