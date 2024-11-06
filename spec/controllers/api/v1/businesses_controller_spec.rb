require 'rails_helper'

RSpec.describe Api::V1::BusinessesController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Business' do
        expect {
          post :create, params: { business: { name: 'New Business' } }
        }.to change(Business, :count).by(1)
      end

      it 'renders a JSON response with the new business' do
        post :create, params: { business: { name: 'New Business' } }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new business' do
        post :create, params: { business: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end
end