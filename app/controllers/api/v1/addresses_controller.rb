class Api::V1::AddressesController < ApplicationController
  before_action :set_organization

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
    params.require(:address).permit(:street, :city, :state, :zip, :country, :organization_id)
  end

  def set_organization
    @organization = current_user.organizations.find(params[:organization_id])
  end
end