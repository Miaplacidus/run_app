class ChallengesController < ApplicationController
  before_action :require_logged_in

  def index
  end

  def show
  end

  def new
  end

  def create
    result = RunPal::CreateChallenge.run({user_id: session[:user_id], sender_id: params[:circle_admin_select], recipient_id: params[:circle_id]})
    @challenge = result.challenge
    @circle_id = params[:circle_id]

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
