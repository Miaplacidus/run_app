module RunPal
  class FilterPostsByAge < UseCase

    def run(inputs)
      inputs[:age] = inputs[:age].to_i
      inputs[:radius] = inputs[:radius].to_i

      post_arr = filter_posts_by_age(inputs)

      success :post_arr => post_arr
    end

    def filter_posts_by_age(attrs)
      RunPal.db.posts_filter_age(attrs[:age], {latitude: attrs[:latitude], longitude: attrs[:longitude], radius: attrs[:radius]})
    end

  end
end
