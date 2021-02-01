class Api::V1::RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.new(registration_params[:user])
    organizations = Organization.where(id: registration_params[:organizations_ids])

    user.organizations << organizations

    if user.save
      token = encode_token({ sub: user.id })
      render json: { user: { id: user.id, email: user.email } , token: token }, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:registration).permit(user: [:email, :password], organizations_ids: [])
  end
end
