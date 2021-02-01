class Api::V1::AuthenticationsController < ApplicationController
  def create
    user = User.find_by(email: authentication_params[:email])

    if user && user.authenticate(authentication_params[:password])
      token = encode_token({ sub: user.id })
      render json: { token: token }, status: :created
    else
      unauthorized_entity
    end
  end

  private

  def authentication_params
    params.require(:authentication).permit(:email, :password)
  end
end