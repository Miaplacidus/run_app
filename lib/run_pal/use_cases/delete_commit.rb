module RunPal
  class DeleteCommit < UseCase

    def run(inputs)

      inputs[:commit_id] = inputs[:commit_id] ? inputs[:commit_id].to_i : nil
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil

      commit = RunPal.db.get_commit(inputs[:commit_id])
      return failure(:commit_does_not_exist) if commit.nil?
      return failure(:user_not_authorized) if commit.user_id != inputs[:user_id]

      delete_commit(inputs)

      deleted = RunPal.db.get_commit(commit.id)
      return failure(:failed_to_delete) if !deleted.nil?

      success :commit => commit
    end

    def delete_commit(attrs)
      RunPal.db.delete_commit(attrs[:commit_id])
    end

  end
end

