module RunPal
  class UpdatePost < UseCase

    def run(inputs)

      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:pace] = inputs[:pace].to_i
      inputs[:post_id] = inputs[:post_id].to_i
      # inputs[:time] = inputs[:time].to a datetime object
      inputs[:min_distance] = inputs[:min_distance].to_i
      inputs[:age_pref] = inputs[:age_pref].to_i
      inputs[:gender_pref] = inputs[:gender_pref].to_i
      inputs[:max_runners] = inputs[:max_runners].to_i
      inputs[:min_amt] = inputs[:min_amt].to_f
      inputs[:latitude] = inputs[:latitude] ? inputs[:latitude].to_f : nil
      inputs[:longitude] = inputs[:longitude] ? inputs[:longitude].to_f : nil

      user = RunPal.db.get_user(inputs[:creator_id])
      post = RunPal.db.get_post(inputs[:post_id])
      return failure (:user_does_not_exist) if user.nil?
      return failure (:not_authorized_to_edit_post) if user.id != post.creator_id

      return failure (:gender_pref_disallowed) if inputs[:user_gender] != inputs[:gender_pref] && inputs[:gender_pref] != 0

      post = update_post(inputs)

      success :post => post
    end

    def update_post(attrs)
      format_attrs = attrs.clone

      format_attrs.delete_if do |name, value|
          setter = "#{name}"
          !RunPal::Post.method_defined?(setter)
      end

      RunPal.db.update_post(format_attrs)
    end

  end
end
