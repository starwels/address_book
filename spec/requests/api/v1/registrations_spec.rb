require 'rails_helper'
require 'support/request_spec_helper'

RSpec.describe "Api::V1::Users", type: :request do
  include RequestSpecHelper

  describe "POST /api/v1/registrations" do
    context 'when params are valid' do
      let(:registration_params) { attributes_for(:user) }

      it "returns status 201" do
        post api_v1_registrations_path, params: { registration: registration_params }
        expect(response).to have_http_status(201)
      end

      it "returns the created user" do
        post api_v1_registrations_path, params: { registration: registration_params }
        expect(json_body[:user][:name]).to eq(registration_params[:name])
      end
    end

    context 'when params are invalid' do
      let(:registration_params) { { name: nil } }

      it "returns status 422" do
        post api_v1_registrations_path, params: { registration: registration_params }
        expect(response).to have_http_status(422)
      end

      it "returns errors" do
        post api_v1_registrations_path, params: { registration: registration_params }
        expect(json_body).to include(:errors)
      end
    end

  end
end