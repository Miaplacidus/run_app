class PostsController < ApplicationController
  # before_action :require_logged_in

  def index
    result = RunPal::GetUser.run({user_id: session[:user_id]})
    @user = result.user
    # location = Geocoder.coordinates(request.remote_ip)
    test_location = Geocoder.coordinates("24.14.95.244")
    puts "Check location here! #{test_location}"
    # puts "Look here!!! #{Time.zone.class}"
    result = RunPal::FilterPostsByGender.run({user_id: session[:user_id], radius: 10, gender_pref: 3, user_lat: test_location[0], user_long: test_location[1]})
    @posts = result.post_arr
  end

  def display
    # By default, gender_pref and location must be provided
    # location = Geocoder.coordinates(request.remote_ip)
    test_location = Geocoder.coordinates("24.14.95.244")
    # post_attributes = post_params.merge({user_lat: location[0], user_long: location[1], user_id: session[:user_id]})

    case params[:filter_select]
      when "0"
        result = RunPal::FilterPostsByGender.run({user_id: session[:user_id], radius: params[:radius], gender_pref: params[:gender_pref], user_lat: test_location[0], user_long: test_location[1]})
        @posts = result.post_arr
        puts "LOOK AT GENDER POSTS #{@posts}"
      when "1"
        result = RunPal::FilterPostsByPace.run({user_id: session[:user_id], pace: params[:pace], radius: params[:radius], gender_pref: params[:gender_pref], user_lat: test_location[0], user_long: test_location[1]})
        @posts = result.post_arr
        puts "LOOK AT PACE POSTS #{result}"
      when "2"
        result = RunPal::FilterPostsByAge.run({user_id: session[:user_id], radius: params[:radius], gender_pref: params[:gender_pref], user_lat: test_location[0], user_long: test_location[1]})
        @posts = result.post_arr
        puts "LOOK AT AGE POSTS #{@posts}"
      when "3"
        start_date = params[:start_time][:day] + '/' + params[:start_time][:month] + '/' + params[:start_time][:year]
        start_hour = params[:start_time][:hour] + ":00"
        start_time = start_date + " " + start_hour

        end_date = params[:end_time][:day] + '/' + params[:end_time][:month] + '/' + params[:end_time][:year]
        end_hour = params[:end_time][:hour] + ":00"
        end_time = end_date + " " + end_hour

        starting = Time.zone.parse(start_time).utc
        ending = Time.zone.parse(end_time).utc

        zone = Time.zone.now.utc
        puts "IN THE ZOOOONE #{zone}"
        puts "GET WITH THE TIMES, begin #{starting.class}"
        puts "GET WITH THE TIMES, end #{ending.inspect}"
        # tz = ActiveSupport::TimeZone[zone].parse(start_date + start_time)
        # puts "ALSO LOOK AT THE TIME #{tz}!"

        result = RunPal::FilterPostsByTime.run({user_id: session[:user_id], start_time: starting, end_time: ending, radius: params[:radius], gender_pref: params[:gender_pref], user_lat: test_location[0], user_long: test_location[1]})
        @posts = result.post_arr
        puts "LOOK AT TIME POSTS #{result}"
      else
        result = RunPal::FilterPostsByGender.run({user_id: session[:user_id], radius: params[:post], gender_pref: params[:gender_pref], user_lat: test_location[0], user_long: test_location[1]})
        @posts = result.post_arr
        puts "LOOK AT LAST GENDER POSTS #{@posts}"
    end


    # @posts = RunPal::FilterPostsByAge.run(post_attributes)
    # flash[:notice] = @posts.failure if !@posts.success?
    respond_to do |format|
      format.js
    end
  end


  def show
    # TODO: Post data including users attending the run and along with their
    # level and rating and a map
    retrieved_user = RunPal::GetUser.run({user_id: params[:creator_id]})
    @creator = retrieved_user.user
    retrieved_list = RunPal::GetPostUsers.run({post_id: params[:post_id]})
    @users_list = retrieved_list.users
    result = RunPal::ShowPost.run({user_id: session[:user_id], post_id: params[:post_id] })
    @max_runners = result.post.max_runners
    @post_id = params[:post_id]

    puts "POST ID HERE: #{@post_id}"
    puts "POSTCREATOR: #{@creator}"
    puts "USER LISTING: #{@users_list}"

    respond_to do |format|
      format.js
    end
  end

  def new
    # @post = RunPal::Post.new({:notes => "", :circle_id => nil})

  end

  def create
    position = Geocoder.coordinates(params[:address])
    address = Geocoder.address(position)

    date = params[:date][:day] + '/' + params[:date][:month] + '/' + params[:date][:year]
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

    # post_attributes = post_params.merge({user_id: session[:user_id], latitude: position[0], longitude: position[1], address: address})
    result = RunPal::CreatePost.run({user_id: session[:user_id], time: utc_time, address: address, latitude: position[0], longitude: position[1], pace: params[:pace], min_distance: params[:distance], gender_pref: params[:gender_pref], min_amt: params[:amount], max_runners: params[:max_runners], notes: params[:notes], age_pref: age_group})
    @post = result.post

    respond_to do |format|
      format.js
    end
  end

  def join
    # Set default amount to 0
    RunPal::JoinPost.run({user_id: session[:user_id], post_id: params[:post_id], amount: 25.00})

    retrieved_user = RunPal::GetUser.run({user_id: params[:creator_id]})
    @creator = retrieved_user.user
    retrieved_list = RunPal::GetPostUsers.run({post_id: params[:post_id]})
    @users_list = retrieved_list.users
    result = RunPal::ShowPost.run({user_id: params[:creator_id], post_id: params[:post_id] })
    @max_runners = result.post.max_runners
    @post_id = params[:post_id]

    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def delete
    # TODO: Show form for deleting post
  end

  def destroy
    @destroyed_post = RunPal::DeletePost.run()
  end


  private

  def post_params
    params.require(:post).permit(:time, :pace, :notes, :min_amt, :min_distance, :age_pref, :gender_pref, :circle_id, :max_runners, :address, :radius)
  end
end
