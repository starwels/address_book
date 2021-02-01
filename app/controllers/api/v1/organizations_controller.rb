class Api::V1::OrganizationsController < ApplicationController
  before_action :authenticate_admin!, only: :create

  def index
    organizations = Organization.all

    render json: { organizations: organizations }, status: :ok
  end

  def create
    organization = Organization.new(organization_params)

    if organization.save
      render json: { organization: organization }, status: :created
    else
      render json: { errors: organization.errors }, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end

  def authenticate_admin!
    unauthorized_entity unless current_user.admin?
  end
end