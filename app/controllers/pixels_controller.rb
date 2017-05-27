class PixelsController < ApplicationController

  # GET /pixels
  def index
    @pixels = Pixel.all

    render json: @pixels
  end

  # POST /pixels
  def create
    rounded_lat = round_down(pixel_params["latitude"], Pixel::PRECISION)
    rounded_long = round_down(pixel_params["longitude"], Pixel::PRECISION)
    @pixel = Pixel.first_or_initialize(:south => rounded_lat, :west => rounded_long)
    
    @pixel.update_attributes(
      {
        :south => rounded_lat,
        :north => rounded_lat + (10 ** -Pixel::PRECISION),
        :west => rounded_long,
        :east => rounded_long + (10 ** -Pixel::PRECISION),
        :colour => pixel_params["colour"]
      }
    )

    render json: @pixel, status: :created, location: @pixel
  rescue
    render json: @pixel.errors, status: :unprocessable_entity
  end

  private
  
    def round_down(number, decimal_place = 0)
      factor = 10 ** decimal_place
      ((number*factor).floor)/factor
    end

    # Only allow a trusted parameter "white list" through.
    def pixel_params
      params.permit(:latitude, :longitude, :colour)
    end
end
