module RunPal
  class UpdateCommit < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:amount] = inputs[:amount].to_f
      inputs[:commit_id] = inputs[:commit_id].to_i
      inputs[:fulfilled] = true if inputs[:fulfilled] == "true"
      inputs[:fulfilled] = false if inputs[:fulfilled] == "false"

      commit = RunPal.db.get_commit(inputs[:commit_id])
      return failure (:commitment_does_not_exist) if commit.nil?
      return failure(:not_authorized_to_edit_commit) if commit.user_id != inputs[:user_id]

      updated_commit = update_commitment(inputs)
      success :commit => updated_commitment
    end

    def update_commitment(attrs)
      RunPal.db.update_commit(attrs[:commit_id], {amount: attrs[:amount], fulfilled: attrs[:fulfilled]})
    end

  end
end
