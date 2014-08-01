class JoinRequestsController < ApplicationController
  before_action :require_logged_in

  def index
  end

  def show
  end

  def new
  end

  def create
     result = RunPal::CreateJoinReq.run({user_id: session[:user_id], circle_id: params[:circle_id]})
     @circle_id = params[:circle_id]

    if result.success?
      @join_req = result.join_req
      puts "JOIN REQ #{@join_req}"
    else
    end

    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def delete
  end

  def destroy
  end
end
