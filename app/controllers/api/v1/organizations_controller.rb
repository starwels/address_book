class Api::V1::OrganizationsController < ApplicationController
  before_action :authenticate_admin!, only: :create

  def index
    businesses = Organization.all
    render json: { businesses: businesses }, status: :ok
  end

  def create
    business = Organization.new(organization_params)
    if business.save
      render json: { business: business }, status: :created
    else
      render json: { errors: business.errors }, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end