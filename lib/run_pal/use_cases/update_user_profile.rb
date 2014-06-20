module RunPal
  class UpdateUser < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:level] = inputs[:level].to_i if inputs[:level]
      inputs[:rating] = inputs[:rating].to_i if inputs[:rating]

      user = RunPal.db.get_user(inputs[:user_id])
      return failure (:user_does_not_exist) if user.nil?

      updated_user = update_user(inputs)
      success :commit => updated_commitment
    end

    def update_commitment(attrs)
      attrs.delete_if do |key, value|
        key != :level && key != :rating
      end
      RunPal.db.update_commit(attrs[:user_id], attrs)
    end

  end
end
