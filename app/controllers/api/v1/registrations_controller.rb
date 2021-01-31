class Api::V1::RegistrationsController < ApplicationController
  def create
    user = User.new(registration_params[:user])
    organizations = Organization.where(id: registration_params[:organizations_ids])

    user.organizations << organizations

    if user.save
      render json: { user: user }, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:registration).permit(user: [:email], organizations_ids: [])
  end
end
