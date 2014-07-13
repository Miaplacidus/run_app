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
      when "1"
        result = RunPal::FilterPostsByPace.run({user_id: session[:user_id], pace: params[:pace], radius: params[:radius], gender_pref: params[:gender_pref], user_lat: test_location[0], user_long: test_location[1]})
        @posts = result.post_arr
        puts "LOOK AT POSTS #{@posts}"
      when "2"
        result = RunPal::FilterPostsByTime.run({user_id: session[:user_id], start_time: params[:start_time], end_time: params[:end_time], radius: params[:radius], gender_pref: params[:gender_pref], user_lat: test_location[0], user_long: test_location[1]})
        @posts = result.post_arr
      when "3"
        result = RunPal::FilterPostsByAge.run({user_id: session[:user_id], age: params[:age], radius: params[:radius], gender_pref: params[:gender_pref], user_lat: test_location[0], user_long: test_location[1]})
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
    # level and rating
  end

  def new
    # @post = RunPal::Post.new({:notes => "", :circle_id => nil})
  end

  def create
    position = Geocoder.coordinates(params[:post][:address])
    address = Geocoder.address(position)
    post_attributes = post_params.merge({user_id: session[:user_id], latitude: position[0], longitude: position[1], address: address})
    @post = RunPal::CreatePost.run(post_attributes)
    if @post.success?
      flash[:notice] = "Successfully created post!"
      redirect_to(:action => 'index')
    else
      render('new')
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
