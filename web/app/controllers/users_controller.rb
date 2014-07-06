class UsersController < ApplicationController

  before_action :require_logged_in, :except => [:index]

  def index
    # Root of app, welcome page w/ app description and login form
    # (see sessions controller) that directs to user dashboard
  end

  def dashboard
    # require_logged_in
    result = RunPal::GetUser.run({user_id: session[:user_id]})
    @user = result.user
    # access to user picture, wallet, next runs, previous runs,
    # weather, calendar, runs compiled in graph form, helpful
    # running videos, their circles, social media sharing, tweets
    # with the hashtag runningbuddy
    # render session
  end

  def show
  end

  # def new
  # end

  # def create
  # end

  # def edit
  # end

  def delete
  end

  def destroy
  end
end
