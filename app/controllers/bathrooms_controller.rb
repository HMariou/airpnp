class BathroomsController < ApplicationController
  def index
    @bathrooms = Bathroom.all
    @markers = @bathrooms.geocoded.map do |bathroom|
      {
        lat: bathroom.latitude,
        lng: bathroom.longitude
      }
    end
  end

  def show
    @bathroom = Bathroom.find(params[:id])
    @user = @bathroom.user
  end

  def new
    @bathroom = Bathroom.new
  end

  def create
    @bathroom = Bathroom.new(bathroom_params)
    @bathroom.user = current_user
    if @bathroom.save
      redirect_to bathroom_path(@bathroom)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @bathroom = Bathroom.find(params[:id])
  end

  def update
    @toilet = Bathroom.find(params[:id])
    @toilet.update(bathroom_params)
    redirect_to bathroom_path(@toilet)
  end

  def destroy
    @bathroom = Bathroom.find(params[:id])
    @bathroom.destroy
    redirect_to my_bathrooms_path, status: :see_other
  end

  def my_bathrooms
    @bathrooms = Bathroom.where(user: current_user)
  end

  private

  def bathroom_params
    params.require(:bathroom).permit(:price, :address, :description, :photo, :latitude, :longitude)
  end
end
