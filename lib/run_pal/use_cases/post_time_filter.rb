module RunPal
  class FilterPostsByTime < UseCase

    def run(inputs)
      inputs[:user_id] = inputs[:user_id] ? inputs[:user_id].to_i : nil
      inputs[:gender_pref] = inputs[:gender_pref] ? inputs[:gender_pref].to_i : nil
      inputs[:radius] = inputs[:radius] ? inputs[:radius].to_i : nil
      inputs[:user_long] = inputs[:user_long] ? inputs[:user_long].to_f : nil
      inputs[:user_lat] = inputs[:user_lat] ? inputs[:user_lat].to_f : nil

      user = RunPal.db.get_user(inputs[:user_id])
      return failure (:user_does_not_exist) if user.nil?

      if inputs[:gender_pref] != 0 && inputs[:gender_pref] != 3
          return failure (:user_cannot_view_opposite_sex_posts) if user.gender != inputs[:gender_pref]
      end

      inputs[:user_gender] = user.gender
      post_arr = filter_posts_by_time(inputs)

      success :post_arr => post_arr
    end

    def filter_posts_by_time(attrs)
      RunPal.db.posts_filter_time(attrs[:start_time], attrs[:end_time], attrs)
    end

  end
end
