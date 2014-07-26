module RunPal
  class CreatePost < UseCase

    def run(inputs)

      inputs[:creator_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil
      inputs[:pace] = inputs[:pace] ? inputs[:pace].to_i : nil
      inputs[:min_distance] = inputs[:min_distance] ? inputs[:min_distance].to_i : nil
      inputs[:age_pref] = inputs[:age_pref] ? inputs[:age_pref].to_i : nil
      inputs[:gender_pref] = inputs[:gender_pref] ? inputs[:gender_pref].to_i : nil
      inputs[:max_runners] = inputs[:max_runners] ? inputs[:max_runners].to_i : nil
      inputs[:min_amt] = inputs[:min_amt] ? inputs[:min_amt].to_f : nil
      inputs[:latitude] = inputs[:latitude] ? inputs[:latitude].to_f : nil
      inputs[:longitude] = inputs[:longitude] ? inputs[:longitude].to_f : nil
      inputs[:circle_id] = inputs[:circle_id] ? inputs[:circle_id].to_i : nil

      user = RunPal.db.get_user(inputs[:creator_id])
      return failure (:user_does_not_exist) if user.nil?
      return failure (:gender_incorrect) if user.gender < 1 || user.gender > 2
      return failure (:gender_pref_disallowed) if user.gender != inputs[:gender_pref] && inputs[:gender_pref] != 0

      post = create_new_post(inputs)
      return failure(:invalid_input) if !post.valid?

      success :post => post
    end

    def create_new_post(attrs)
      format_attrs = attrs.clone
      format_attrs.delete_if do |name, value|
          setter = "#{name}"
          !RunPal::Post.method_defined?(setter)
      end
      RunPal.db.create_post(format_attrs)
    end

  end
end
