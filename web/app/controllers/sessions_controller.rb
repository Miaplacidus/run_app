class SessionsController < ApplicationController

  def attempt_login
    result = RunPal::LogIn.run({auth: env["omniauth.auth"]})
    puts env["omniauth.auth"]
    if result.success?
      session[:user_id] = result.user.id
      session[:username] = result.user.first_name
      flash[:notice] = "Logged in!"
      redirect_to(:controller => 'users', :action => 'dashboard')
    else
      flash[:notice] = result.error
      redirect_to root_path
    end
  end

  def logout
    session[:user_id] = nil
    session[:username] = nil
    flash[:notice] = "Logged out"
    redirect_to root_path
  end
end
