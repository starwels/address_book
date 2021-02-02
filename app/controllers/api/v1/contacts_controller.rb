class Api::V1::ContactsController < ApplicationController
  before_action :set_organization, except: :destroy
  before_action :check_organization, only: [:create, :update]

  def index
    contacts = @organization.contacts
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
    organizations = current_user.organizations.all
    contact = Contact.find_document(params[:id])

    return render json: {}, status: :no_content if contact.nil?
    return unauthorized_entity if organizations.map(&:id).exclude?(contact.organization_id)

    contact.delete
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :phone, :organization_id)
  end

  def check_organization
    unauthorized_entity if @organization.nil?
  end

  def set_organization
    @organization = current_user.organizations.find(params[:organization_id] || params[:contact][:organization_id])
  end
end