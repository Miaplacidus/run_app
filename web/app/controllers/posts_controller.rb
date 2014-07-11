class PostsController < ApplicationController
  before_action :require_logged_in

  def index
    # location = Geocoder.address(request.remote_ip)
    puts "Look here!!! #{Time.zone}"
  end

  def display
    # By default, gender_pref and location must be provided
    location = Geocoder.coordinates(request.remote_ip)
    post_attributes = post_params.merge({user_lat: location[0], user_long: location[1], user_id: sessions[:user_id]})
    # case params[:filter][]

    # end
    @posts = RunPal::FilterPostsByAge.run(post_attributes)
    flash[:notice] = @posts.failure if !@posts.success?
  end

  def circle_filter

  end

  def

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
    post_attributes = post_params.merge({user_id: sessions[:user_id], latitude: position[0], longitude: position[1], address: address})
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
    params.require(:post).permit(:time, :pace, :notes, :min_amt, :min_distance, :age_pref, :gender_pref, :circle_id, :max_runners, :address)
  end
end
