class TimeWindowsController < ApplicationController
 skip_before_filter :verify_authenticity_token 
  def show
    redirect_if_business
    @time_window = TimeWindow.find params[:id]
    @offer = @time_window.offer

    if @time_window.end_time < Time.now
      redirect_to deals_path
    end
  end

  def time_remaining
    time_window = TimeWindow.find params[:id]
    seconds_remaining = time_window.end_time.to_i - Time.now.to_i
    render json: {seconds: (seconds_remaining), deal_length: time_window.end_time.to_i - time_window.start_time.to_i }
  end

  def percentage_remaining
    time_window = TimeWindow.find params[:id]
    render json: {}
  end

  def create
    redirect_if_business
    @offer = Offer.find params[:offer_id]      
    @time_window = TimeWindow.find_or_create_by(user_id: current_user.id, offer: @offer)

    if @time_window.end_time > Time.now
      redirect_to [@offer, @time_window]
    else
      redirect_to deals_path
    end
  end

  private

  def redirect_if_business
    if current_business
      redirect_to offer_path(params[:offer_id])
    end
  end

end
