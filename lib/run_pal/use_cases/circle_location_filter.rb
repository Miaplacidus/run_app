module RunPal
  class FilterCirclesByLocation < UseCase

    def run(inputs)
      inputs[:user_lat] = inputs[:user_lat] ? inputs[:user_lat].to_i : nil
      inputs[:user_long] = inputs[:user_long] ? inputs[:user_long].to_i : nil
      inputs[:radius] = inputs[:radius] ? inputs[:radius].to_i : nil

      circles = get_nearby_circles(inputs)

      success :circle_arr => circles
    end

    def get_nearby_circles(attrs)
      RunPal.db.circles_filter_location(attrs)
    end

  end
end