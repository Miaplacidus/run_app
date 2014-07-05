class SessionsController < ApplicationController


  def login

  end

  def attempt_login
    result = RunPal::LogIn.run({auth: env["omniauth.auth"]})
    if result.succes?
      session[:user_id] = result.user.id
      session[:user_name] = result.user.first_name
      flash[:notice] = "Logged in!"
      # Add a
    else
      flash[:notice] = result.error
      redirect_to '/users/index'
    end
  end
end
