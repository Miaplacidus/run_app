module RunPal
  class ShowOpenCircles < UseCase

    def run(inputs)
      inputs[:user_lat] = inputs[:user_lat].to_i
      inputs[:user_long] = inputs[:user_long].to_i
      inputs[:radius] = inputs[:radius].to_i

      circle_arr = get_open_circles(inputs)

      success :circle_arr => circle_arr
    end

    def get_open_circles(attrs)
      RunPal.db.circles_filter_full(attrs)
    end

  end
end
