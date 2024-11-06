require 'rails_helper'

RSpec.describe 'Addresses', type: :request do
  describe 'POST /api/v1/addresses' do
    let(:user) { create(:user) }
    let(:valid_attributes) { { street: '123 Main St', city: 'Anytown', state: 'CA', zip: '12345', country: 'USA', user_id: user.id } }

    context 'with valid parameters' do
      it 'creates a new Address' do
        expect {
          post api_v1_addresses_path, params: { address: valid_attributes }
        }.to change(Address, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Address' do
        expect {
          post api_v1_addresses_path, params: { address: { street: '' } }
        }.not_to change(Address, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end