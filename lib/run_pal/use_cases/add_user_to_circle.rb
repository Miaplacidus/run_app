module RunPal
  class AddUserToCircle < UseCase

    def run(inputs)
      inputs[:circle_id] = inputs[:circle_id].to_i
      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:new_user_id] = inputs[:new_user_id].to_i

      user = RunPal.db.get_user(inputs[:new_user_id])
      return failure(:user_does_not_exist) if user.nil?

      circle = RunPal.db.get_circle(inputs[:circle_id])
      return failure (:circle_does_not_exist) if circle.nil?
      return failure (:not_authorized_to_edit_circle) if circle.admin_id != inputs[:user_id]
      return failure (:circle_full) if circle.member_ids.length == circle.max_members

      updated_circle = new_circle_member(inputs)
      success :circle => updated_circle, :user => user
    end

    def new_circle_member(attrs)
      RunPal.db.add_user_to_circle(attrs[:circle_id],[attrs[:new_user_id]])
    end

  end
end
