module RunPal
  class CreateCircle < UseCase

    def run(inputs)
      inputs[:admin_id] = inputs[:admin_id].to_i

      user = RunPal.db.get_user(inputs[:admin_id])
      return failure (:user_does_not_exist) if user.nil?

      names_hash = RunPal.db.get_circle_names
      return failure(:name_taken) if names_hash[inputs[:name]]

      circle = create_new_circle(inputs)
      return failure(:invalid_input) if !circle.valid?

      success :circle => circle

    end

    def create_new_circle(attrs)
      RunPal.db.create_circle(attrs)
    end

  end
end
