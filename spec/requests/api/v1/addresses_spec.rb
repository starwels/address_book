require 'rails_helper'

RSpec.describe 'Addresses', type: :request do
  describe 'POST /api/v1/addresses' do
    it 'creates a new address' do
      organization = create(:organization)
      user = create(:user)
      sign_in user
      post api_v1_addresses_path, params: { address: { street: '123 Main St', city: 'Anytown', state: 'State', zip: '12345', country: 'Country', organization_id: organization.id } }
      expect(response).to have_http_status(:created)
    end
  end
end