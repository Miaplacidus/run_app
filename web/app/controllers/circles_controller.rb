class CirclesController < ApplicationController
  before_action :require_logged_in

  def index
    result = RunPal::ShowOpenCircles.run({params})
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def delete
  end

  def destroy
  end
end
