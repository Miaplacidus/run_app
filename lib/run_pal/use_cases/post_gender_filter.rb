module RunPal
  class FilterPostsByGender < UseCase

    def run(inputs)
      user = RunPal.db.get_user(inputs[:user_id])
      if inputs[:gender] != 0
          return failure (:user_cannot_view_opposite_sex_posts) if user.gender != inputs[:gender]
      end

      post_arr = filter_posts_by_gender(inputs)

      success :post_arr => post_arr
    end

    def filter_posts_by_gender(attrs)
      RunPal.db.posts_filter_gender(attrs)
    end

  end
end
