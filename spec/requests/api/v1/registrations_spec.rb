require 'rails_helper'
require 'support/request_spec_helper'

RSpec.describe "Api::V1::Users", type: :request do
  include RequestSpecHelper

  describe "POST /api/v1/registrations" do
    context 'when params are valid' do
      let(:organizations_ids) { create_list(:organization, 3).map(&:id) }
      let(:registration_params) do
        {
          registration: {
            user: attributes_for(:user),
            organizations_ids: organizations_ids,
          }
        }
      end

      it "returns status 201" do
        post api_v1_registrations_path, params: registration_params
        expect(response).to have_http_status(201)
      end

      it "returns the created user" do
        post api_v1_registrations_path, params: registration_params
        expect(json_body[:user][:email]).to eq(registration_params[:registration][:user][:email])
      end

      it "returns the user token" do
        post api_v1_registrations_path, params: registration_params
        expect(json_body[:token]).to eq(JWT.encode({ sub: json_body[:user][:id] }, Rails.application.credentials.read))
      end

      it "has 3 associated organizations" do
        post api_v1_registrations_path, params: registration_params
        user = User.find(json_body[:user][:id])
        expect(user.organizations.size).to eq(3)
      end
    end

    context 'when params are invalid' do
      let(:registration_params) do
        {
          registration: {
            user: {
              email: nil
            }
          }
        }
      end

      it "returns status 422" do
        post api_v1_registrations_path, params: registration_params
        expect(response).to have_http_status(422)
      end

      it "returns errors" do
        post api_v1_registrations_path, params: registration_params
        expect(json_body).to include(:errors)
      end
    end
  end
end