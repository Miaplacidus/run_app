class CirclesController < ApplicationController
  before_action :require_logged_in

  def index
    # ip_address = request.remote_ip
    pretend_ip = "24.14.95.244"
    puts "LOOK HERE FOR IP #{ip_address}"
    # result = RunPal::FilterCirclesByLocation.run({})
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
