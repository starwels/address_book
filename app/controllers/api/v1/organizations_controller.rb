class Api::V1::OrganizationsController < ApplicationController
  def index
    organizations = Organization.all

    render json: organizations, status: :ok
  end

  def create
    organization = Organization.new(organization_params)

    if organization.save
      render json: organization, status: :created
    else
      render json: { errors: organization.errors }, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end