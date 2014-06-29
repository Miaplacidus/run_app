module RunPal
  class CreateCircle < UseCase

    def run(inputs)
      inputs[:admin_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil
      inputs[:max_members] = inputs[:max_members] ? inputs[:max_members].to_i : nil
      inputs[:latitude] = inputs[:latitude] ? inputs[:latitude].to_f : nil
      inputs[:longitude] = inputs[:longitude] ? inputs[:longitude].to_f : nil
      inputs[:level] = inputs[:level] ? inputs[:level].to_i : nil

      user = RunPal.db.get_user(inputs[:admin_id])
      return failure (:user_does_not_exist) if user.nil?

      names_hash = RunPal.db.get_circle_names
      return failure(:name_taken) if names_hash[inputs[:name]]

      circle = create_new_circle(inputs)
      return failure(:invalid_input) if !circle.valid?

      success :circle => circle

    end

    def create_new_circle(attrs)
      format_attrs = attrs.clone

      format_attrs.delete_if do |name, value|
          setter = "#{name}"
          !RunPal::Circle.method_defined?(setter)
      end

      RunPal.db.create_circle(attrs)
    end

  end
end
