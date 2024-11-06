```json
[
    {
        "filename": "app/controllers/api/v1/addresses_controller.rb",
        "code": "class Api::V1::AddressesController < ApplicationController\n  before_action :set_user, only: [:create]\n\n  def create\n    address = Address.new(address_params)\n    if address.save\n      render json: { address: address }, status: :created\n    else\n      render json: { errors: address.errors }, status: :unprocessable_entity\n    end\n  end\n\n  private\n\n  def address_params\n    params.require(:address).permit(:street, :city, :state, :zip, :country, :user_id)\n  end\n\n  def set_user\n    @user = User.find(params[:user_id])\n  rescue ActiveRecord::RecordNotFound\n    render json: { error: 'User not found' }, status: :not_found\n  end\nend"
    },
    {
        "filename": "app/models/address.rb",
        "code": "class Address < ApplicationRecord\n  belongs_to :user\n\n  validates :street, presence: true\n  validates :city, presence: true\n  validates :state, presence: true\n  validates :zip, presence: true\n  validates :country, presence: true\nend"
    },
    {
        "filename": "config/routes.rb",
        "code": "Rails.application.routes.draw do\n  root 'health_check#index'\n  namespace :api do\n    namespace :v1 do\n      resources :authentications, only: [:create]\n      resources :contacts, only: [:index, :create, :update, :destroy]\n      resources :organizations, only: [:index, :create]\n      resources :registrations, only: [:create]\n      resources :addresses, only: [:create]\n    end\n  end\nend"
    },
    {
        "filename": "spec/requests/api/v1/addresses_spec.rb",
        "code": "require 'rails_helper'\n\nRSpec.describe 'Addresses', type: :request do\n  describe 'POST /api/v1/addresses' do\n    let(:user) { create(:user) }\n    let(:valid_attributes) { { street: '123 Main St', city: 'Anytown', state: 'Anystate', zip: '12345', country: 'USA', user_id: user.id } }\n\n    context 'with valid parameters' do\n      it 'creates a new Address' do\n        expect {\n          post api_v1_addresses_path, params: { address: valid_attributes }\n        }.to change(Address, :count).by(1)\n        expect(response).to have_http_status(:created)\n      end\n    end\n\n    context 'with invalid parameters' do\n      it 'does not create a new Address' do\n        expect {\n          post api_v1_addresses_path, params: { address: { street: '' } }\n        }.not_to change(Address, :count)\n        expect(response).to have_http_status(:unprocessable_entity)\n      end\n    end\n  end\nend"
    }
]
```