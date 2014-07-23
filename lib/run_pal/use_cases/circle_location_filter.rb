module RunPal
  class FilterCirclesByLocation < UseCase

    def run(inputs)
      inputs[:user_lat] = inputs[:user_lat] ? inputs[:user_lat].to_f : nil
      inputs[:user_long] = inputs[:user_long] ? inputs[:user_long].to_f : nil
      inputs[:radius] = inputs[:radius] ? inputs[:radius].to_i : nil

      circles = get_nearby_circles(inputs)

      success :circle_arr => circles
    end

    def get_nearby_circles(attrs)
      RunPal.db.circles_filter_location(attrs[:user_lat], attrs[:user_long], attrs[:radius])
    end

  end
end
