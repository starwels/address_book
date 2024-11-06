class Api::V1::BusinessesController < ApplicationController
  before_action :authenticate_admin!, only: :create

  def index
    businesses = Business.all
    render json: { businesses: businesses }, status: :ok
  end

  def create
    business = Business.new(business_params)
    if business.save
      render json: { business: business }, status: :created
    else
      render json: { errors: business.errors }, status: :unprocessable_entity
    end
  end

  private

  def business_params
    params.require(:business).permit(:name)
  end
end