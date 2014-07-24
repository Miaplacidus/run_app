module RunPal
  class GetCircleMembers < UseCase
    def run(inputs)
      inputs[:circle_id] = inputs[:circle_id] ? inputs[:circle_id].to_i : nil

      members = RunPal.db.get_circle_members(inputs[:circle_id])

      success :members => members
    end
  end

end
