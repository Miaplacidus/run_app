module RunPal
  class FilterPostsByCircle < UseCase

    def run(inputs)

      circle = RunPal.db.get_circle(inputs[:circle_id])
      return failure(:circle_does_not_exist) if circle.nil?

      post_arr = filter_posts_by_circle(inputs[:circle_id])

      success :post_arr => post_arr
    end

    def filter_posts_by_circle(attrs)
      RunPal.db.get_circle_posts(attrs)
    end

  end
end
