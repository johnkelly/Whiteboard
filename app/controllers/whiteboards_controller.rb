class WhiteboardsController < ApplicationController
  before_filter :authenticate_subscriber!
  before_filter :find_models

  def index
    @whiteboards = @subscription.drawings.page(params[:page]).per_page(10)
  end

  def create
    @whiteboard = @subscription.drawings.new
    @whiteboard.canvas = Drawing.blank_canvas
    if @whiteboard.save
      redirect_to whiteboard_url(@whiteboard)
    else
      flash[:alert] = @whiteboard.errors.full_messages.first
      redirect_to whiteboards_url
    end
  end

  def update
    @whiteboard = @subscription.drawings.find(params[:id])
    @whiteboard.generate_image_from_canvas!(params[:image_data]) unless Rails.env.test?

    respond_to do |format|
      format.js
    end
  end

  def show
    @whiteboard = @subscription.drawings.find(params[:id])
  end

  private

  def find_models
    @subscription = current_user.subscription
  end
end