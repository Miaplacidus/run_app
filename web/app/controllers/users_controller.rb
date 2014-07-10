class UsersController < ApplicationController

  before_action :require_logged_in, :except => [:index]

  def index
    # Root of app, welcome page w/ app description and login form
    # (see sessions controller) that directs to user dashboard
  end

  def dashboard
    result = RunPal::GetUser.run({user_id: session[:user_id]})
    @user = result.user
    # access to user picture, wallet, next runs, previous runs,
    # weather, calendar, runs compiled in graph form, helpful
    # running videos, their circles, social media sharing, tweets
    # with the hashtag runningbuddy

    # render session
  end

  def delete
    # TODO: Display delete account form
    result = RunPal::GetUser.run({user_id: session[:user_id]})
    @user = result.user
    sessions[:user_id] = nil
    session[:username] = nil
  end

  def destroy
    # TODO: Add method and use case for destroying user accounts
    user = RunPal::DeleteUser.run({user_id: session[:user_id]})

    if user.success?
      flash[:notice] = "Account successfully deleted!"
      redirect_to(:action => 'index')
    else
      flash[:notice] = "Account deletion unsuccessful!"
      redirect_to(:action => 'dashboard')
    end
  end

end
