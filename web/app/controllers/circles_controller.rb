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
    result = RunPal::CreateJoinReq.run({user_id: session[:user_id], circle_id: params[:circle_id]})

    if result.success?
      @join_req = result.join_req
      puts "JOIN REQ #{@join_req}"
    else
    end

    respond_to do |format|
      format.js
    end
  end

  def show
    retrieved_user = RunPal::GetUser.run({user_id: params[:admin_id]})
    @admin = retrieved_user.user

    retrieved_list = RunPal::GetCircleMembers.run({circle_id: params[:circle_id]})
    @members_list = retrieved_list.members

    @circle_id = params[:circle_id]
    @max_members = params[:max]

    respond_to do |format|
      format.js
    end
  end

  def create
    position = Geocoder.coordinates(params[:city])
    city = Geocoder.address(position)

    result = RunPal::CreateCircle.run({user_id: session[:user_id], name: params[:name], max_members: params[:max_members], description: params[:description], city: city, level: params[:level], latitude: position[0], longitude: position[1]})
    @circle = result.circle

    respond_to do |format|
      format.js
    end
  end

  def challenge
    result = RunPal::CreateChallenge.run({user_id: session[:user_id], sender_id: params[:sender], recipient_id: params[:recipient]})
    @challenge = result.challenge

    respond_to do |format|
      format.js
    end
  end

  def admin
    result = RunPal::GetUserCircles.run({user_id: session[:user_id]})
    @circles = result.circles

    respond_to do |format|
      format.html {render 'circles/admin.html.erb'}
      format.js {render 'circles/admin.js.erb'}
    end
  end

  def adminview
    result = RunPal::GetAdminCircles.run({user_id: session[:user_id]})
    @circles = result.circles

    respond_to do |format|
      format.js
    end
  end

  def circleposts
    result = RunPal::FilterPostsByCircle.run({circle_id: params[:circle_id]})
    @posts = result.post_arr

    @circle_id = params[:circle_id]

    puts "#{result}"
    puts "#{result.post_arr}"

    respond_to do |format|
      format.js
    end
  end

  def getpostform
    @circle_id = params[:circle_id].to_i

    respond_to do |format|
      format.js
    end
  end

  def createcirclepost
    result = RunPal::GetUser.run({user_id: session[:user_id]})
    @user = result.user

    position = Geocoder.coordinates(params[:address])
    address = Geocoder.address(position)

    date = params[:day][:day] + '/' + params[:month_select] + '/' + params[:year][:year]
    hour = params[:date][:hour] + ':' + params[:date][:minute]
    time = date + " " + hour
    utc_time = Time.zone.parse(time).utc

    age_group = 0
    if params[:age] == 1
      result = RunPal::GetUser(user_id: session[:user_id])

      if result.success?
        age_group = result.age_group
      end
    end

    result = RunPal::CreatePost.run({user_id: session[:user_id], time: utc_time, address: address, latitude: position[0], longitude: position[1], pace: params[:pace], min_distance: params[:distance], gender_pref: params[:gender_pref], min_amt: params[:amount], max_runners: params[:max_runners], notes: params[:notes], age_pref: age_group, circle_id: params[:circle_id]})
    @post = result.post

    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def destroy
  end
end
