class SessionsController < ApplicationController

  def login

  end

  def attempt_login
    result = RunPal::LogIn.run({auth: env["omniauth.auth"]})
    puts env["omniauth.auth"]
    if result.success?
      session[:user_id] = result.user.id
      session[:user_name] = result.user.first_name
      flash[:notice] = "Logged in!"
      redirect_to(:controller => 'users', :action => 'dashboard')
    else
      flash[:notice] = result.error
      redirect_to root_path
    end
  end
end
