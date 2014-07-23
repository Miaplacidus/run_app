class CirclesController < ApplicationController
  before_action :require_logged_in

  def index
    result = RunPal::GetUser.run({user_id: session[:user_id]})
    @user = result.user
     # location = Geocoder.coordinates(request.remote_ip)
    test_location = Geocoder.coordinates("24.14.95.244")
    puts "Check location here! #{test_location}"

    result = RunPal::FilterCirclesByLocation.run({user_lat: test_location[0], user_long: test_location[1], radius: 1 })
    @circles = result.circle_arr
  end

  def display

    # location = Geocoder.coordinates(request.remote_ip)
    test_location = Geocoder.coordinates("24.14.95.244")

    case params[:capacity]
      when "0"
        result = RunPal::FilterCirclesByLocation.run({user_lat: test_location[0], user_long: test_location[1], radius: params[:radius] })
        @circles = result.circle_arr
        puts "LOOK AT CIRCLES BY LOCATION #{@circles}"
      when "1"
        result = RunPal::ShowOpenCircles.run({user_lat: test_location[0], user_long: test_location[1], radius: params[:radius] })
        @circles = result.circle_arr
      else
        result = RunPal::FilterCirclesByLocation.run({user_lat: test_location[0], user_long: test_location[1], radius: params[:radius] })
        @circles = result.circle_arr
    end

    respond_to do |format|
      format.js
    end
  end

  def join

  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def delete
  end

  def destroy
  end
end
