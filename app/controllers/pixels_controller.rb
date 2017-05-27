class PixelsController < ApplicationController

  # GET /pixels
  def index
    last_updated_at = params[:last_updated_at]
    if last_updated_at.present?
      @pixels = Pixel.where("updated_at >= ?", Time.at(last_updated_at.to_i))
    else
      @pixels = Pixel.all
    end

    render json: @pixels
  end

  # POST /pixels
  def create
    rounded_lat = round_down(pixel_params["latitude"], Pixel::PRECISION)
    rounded_long = round_down(pixel_params["longitude"], Pixel::PRECISION)
    @pixel = Pixel.find_or_initialize_by(:south => rounded_lat, :west => rounded_long)

    @pixel.update_attributes(
      {
        :south => rounded_lat.round(4),
        :north => (rounded_lat + (10 ** -Pixel::PRECISION)).round(4),
        :west => rounded_long.round(4),
        :east => (rounded_long + (10 ** -Pixel::PRECISION)).round(4),
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
      ((number*factor).floor)/factor.to_f
    end

    # Only allow a trusted parameter "white list" through.
    def pixel_params
      params.permit(:latitude, :longitude, :colour)
    end
end
