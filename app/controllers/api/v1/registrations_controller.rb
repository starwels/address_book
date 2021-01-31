class Api::V1::RegistrationsController < ApplicationController
  def create
    user = User.new(registration_params)

    if user.save
      render json: { user: user }, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:email)
  end
end