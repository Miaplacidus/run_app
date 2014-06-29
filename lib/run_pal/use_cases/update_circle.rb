module RunPal
  class UpdateCircle < UseCase

    def run(inputs)
      inputs[:circle_id] = inputs[:circle_id] ? inputs[:circle_id].to_i : nil
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil
      inputs[:latitude] = inputs[:latitude] ? inputs[:latitude].to_f : nil
      inputs[:longitude] = inputs[:longitude] ? inputs[:longitude].to_f : nil
      inputs[:max_members] = inputs[:max_members] ? inputs[:max_members].to_i : nil
      inputs[:level] = inputs[:level] ? inputs[:level].to_i : nil

      circle = RunPal.db.get_circle(inputs[:circle_id])
      return failure (:circle_does_not_exist) if circle.nil?
      return failure (:not_authorized_to_edit_circle) if circle.admin_id != inputs[:user_id]

      updated_circle = update_circle(inputs)
      success :circle => updated_circle
    end

    def update_circle(attrs)
      format_attrs = attrs.clone

      format_attrs.delete_if do |name, value|
          setter = "#{name}"
          !RunPal::Circle.method_defined?(setter)
      end

      RunPal.db.update_circle(attrs[:circle_id], format_attrs)
    end

  end
end
