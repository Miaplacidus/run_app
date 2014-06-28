module RunPal
  class FilterPostsByAge < UseCase

    def run(inputs)
      inputs[:radius] = inputs[:radius] ? inputs[:radius].to_i : nil
      inputs[:user_long] = inputs[:user_long] ? inputs[:user_long].to_f : nil
      inputs[:user_lat] = inputs[:user_lat] ? inputs[:user_lat].to_f : nil
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil
      inputs[:gender_pref] = inputs[:gender_pref] ? inputs[:gender_pref].to_i : nil

      user = RunPal.db.get_user(inputs[:user_id])
      inputs[:user_gender] = user.gender

      age_group = RunPal.db.get_user_age(user.id)
      inputs[:age] = age_group

      post_arr = filter_posts_by_age(inputs)
      success :post_arr => post_arr
    end

    def filter_posts_by_age(attrs)
      RunPal.db.posts_filter_age(attrs[:age], attrs)
    end

  end
end
