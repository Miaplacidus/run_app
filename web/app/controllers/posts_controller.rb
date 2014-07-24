class PostsController < ApplicationController
  before_action :require_logged_in

  def index
    result = RunPal::GetUser.run({user_id: session[:user_id]})
    @user = result.user
    # location = Geocoder.coordinates(request.remote_ip)
    test_location = Geocoder.coordinates("24.14.95.244")
    result = RunPal::FilterPostsByGender.run({user_id: session[:user_id], radius: 1, gender_pref: 3, user_lat: test_location[0], user_long: test_location[1]})
    @posts = result.post_arr
  end

  def display
    # By default, gender_pref and location must be provided
    # location = Geocoder.coordinates(request.remote_ip)
    test_location = Geocoder.coordinates("24.14.95.244")

    case params[:filter_select]
      when "0"
        result = RunPal::FilterPostsByGender.run({user_id: session[:user_id], radius: params[:radius], gender_pref: params[:gender_pref], user_lat: test_location[0], user_long: test_location[1]})
        @posts = result.post_arr
      when "1"
        result = RunPal::FilterPostsByPace.run({user_id: session[:user_id], pace: params[:pace], radius: params[:radius], gender_pref: params[:gender_pref], user_lat: test_location[0], user_long: test_location[1]})
        @posts = result.post_arr
      when "2"
        result = RunPal::FilterPostsByAge.run({user_id: session[:user_id], radius: params[:radius], gender_pref: params[:gender_pref], user_lat: test_location[0], user_long: test_location[1]})
        @posts = result.post_arr
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

        result = RunPal::FilterPostsByTime.run({user_id: session[:user_id], start_time: starting, end_time: ending, radius: params[:radius], gender_pref: params[:gender_pref], user_lat: test_location[0], user_long: test_location[1]})
        @posts = result.post_arr
      else
        result = RunPal::FilterPostsByGender.run({user_id: session[:user_id], radius: params[:post], gender_pref: params[:gender_pref], user_lat: test_location[0], user_long: test_location[1]})
        @posts = result.post_arr
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

    respond_to do |format|
      format.js
    end
  end

  def create
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

  def checkin
    result = RunPal::CheckIn.run({user_id: session[:user_id], user_lat: params[:user_lat], user_long:params[:user_lon], post_id: params[:id] })

    if result.success?
      @post = result.post
    else
      @error = result.error
    end

    respond_to do |format|
      format.js
    end
  end

  def admin
    result = RunPal::GetUser.run({user_id: session[:user_id]})
    @user = result.user

    result = RunPal::GetUserPosts.run({user_id: session[:user_id]})
    @posts = result.posts

    respond_to do |format|
      format.html {render 'posts/admin.html.erb'}
      format.js {render 'posts/admin.js.erb'}
    end
  end

  def adminview
    result = RunPal::GetAdminPosts.run({user_id: session[:user_id]})
    @posts = result.posts
    respond_to do |format|
      format.js
    end
  end

  def destroy
    RunPal::DeletePost.run({user_id: session[:user_id], post_id: params[:id]})
    result = RunPal::GetUserPosts.run({user_id: session[:user_id]})
    @posts = result.posts

    respond_to do |format|
      format.js
    end
  end


  private

  def post_params
    params.require(:post).permit(:time, :pace, :notes, :min_amt, :min_distance, :age_pref, :gender_pref, :circle_id, :max_runners, :address, :radius)
  end
end
