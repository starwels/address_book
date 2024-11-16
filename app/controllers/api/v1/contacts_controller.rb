class Api::V1::ContactsController < ApplicationController
  before_action :set_business, except: :destroy
  before_action :check_business, only: [:create, :update]

  def index
    contacts = @business.contacts
    render json: { contacts: contacts }
  end

  def create
    contact = Contact.new(contact_params)
    if contact.save
      render json: { contact: contact.to_json }, status: :created
    else
      render json: { errors: contact.errors }, status: :unprocessable_entity
    end
  end

  def update
    contact = Contact.find_document(params[:id])
    if contact.update(contact_params)
      render json: { contact: contact.to_json }, status: :ok
    else
      render json: { errors: contact.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    businesses = current_user.businesses.all
    contact = Contact.find_document(params[:id])
    return render json: {}, status: :no_content if contact.nil?
    return unauthorized_entity if businesses.map(&:id).exclude?(contact.business_id)
    contact.delete
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :phone, :business_id)
  end

  def check_business
    unauthorized_entity if @business.nil?
  end

  def set_business
    @business = current_user.businesses.find(params[:business_id] || params[:contact][:business_id])
  end
end