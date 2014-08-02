class JoinRequestsController < ApplicationController
  before_action :require_logged_in

  def adminlist
    result = RunPal::ShowJoinRequestsAdmin.run({user_id: session[:user_id], circle_id: params[:circle_id]})
    @users = result.users

    @circle_id = params[:circle_id]

    respond_to do |format|
      format.js
    end
  end

  def create
     result = RunPal::CreateJoinReq.run({user_id: session[:user_id], circle_id: params[:circle_id]})
     @circle_id = params[:circle_id]

    if result.success?
      @join_req = result.join_req
    else

    end

    respond_to do |format|
      format.js
    end
  end

  def decide
    @circle = nil

    if params[:commit] == "Accept"
      result = RunPal::AcceptJoinRequest.run({admin_id: session[:user_id], user_id: params[:user_id], circle_id: params[:circle_id]})
      puts "See result! #{result}"
      puts "#{session[:user_id]}"

      @circle = result.circle
      @user = result.user

      retrieved_user = RunPal::GetUser.run({user_id: @circle.admin_id})
      @admin = retrieved_user.user

      retrieved_list = RunPal::GetCircleMembers.run({circle_id: params[:circle_id]})
      @members_list = retrieved_list.members

      @max_members = @circle.max_members

    elsif params[:commit] == "Delete"
      result = RunPal::RejectJoinRequest.run({admin_id: session[:user_id], user_id: params[:user_id], circle_id: params[:circle_id]})
      @join_req = result.deleted_req
    end

    respond_to do |format|
      format.js
    end
  end


  def edit
  end


  def destroy
  end
end
