module RunPal
  class UpdateCircle < UseCase

    def run(inputs)
      inputs[:circle_id] = inputs[:circle_id].to_i
      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:latitude] = inputs[:latitude].to_f
      inputs[:longitude] = inputs[:longitude].to_f
      inputs[:max_members] = inputs[:max_members].to_i
      inputs[:level] = inputs[:level].to_i

      circle = RunPal.db.get_circle(inputs[:circle_id])
      return failure (:circle_does_not_exist) if circle.nil?
      return failure (:not_authorized_to_edit_circle) if circle.admin_id != inputs[:user_id]

      updated_circle = update_circle(inputs)
      success :circle => updated_circle
    end

    def update_circle(attrs)
      format_attrs = attrs.clone
      format_attrs.delete(:circle_id)
      format_attrs.delete(:user_id)
      RunPal.db.update_circle(attrs[:circle_id], attrs_sans_circleid)
    end

  end
end
