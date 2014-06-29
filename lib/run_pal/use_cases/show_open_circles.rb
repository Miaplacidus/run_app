module RunPal
  class ShowOpenCircles < UseCase

    def run(inputs)
      inputs[:user_lat] = inputs[:user_lat] ? inputs[:user_lat].to_i : nil
      inputs[:user_long] = inputs[:user_long] ? inputs[:user_long].to_i : nil
      inputs[:radius] = inputs[:radius] ? inputs[:radius].to_i : nil

      circle_arr = get_open_circles(inputs)

      success :circle_arr => circle_arr
    end

    def get_open_circles(attrs)
      RunPal.db.circles_filter_full(attrs)
    end

  end
end
