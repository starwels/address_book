class Api::V1::AddressesController < ApplicationController
  before_action :set_user, only: [:create]

  def create
    address = Address.new(address_params)
    if address.save
      render json: { address: address }, status: :created
    else
      render json: { errors: address.errors }, status: :unprocessable_entity
    end
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :state, :zip, :country, :user_id)
  end

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end
end