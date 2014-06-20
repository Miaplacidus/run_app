module RunPal
  class FilterPostsByAge < UseCase

    def run(inputs)
      inputs[:age] = inputs[:age].to_i
      inputs[:radius] = inputs[:radius].to_i
      inputs[:user_long] = inputs[:user_long].to_f
      inputs[:user_lat] = inputs[:user_lat].to_f
      inputs[:user_id] = inputs[:user_id].to_i
      inputs[:gender_pref] = inputs[:gender_pref].to_i

      user = RunPal.db.get_user(inputs[:user_id])
      inputs[:user_gender] = user.gender

      post_arr = filter_posts_by_age(inputs)
      success :post_arr => post_arr
    end

    def filter_posts_by_age(attrs)
      RunPal.db.posts_filter_age(attrs[:age], attrs)
    end

  end
end
