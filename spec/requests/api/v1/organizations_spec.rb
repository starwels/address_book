require 'rails_helper'
require 'support/request_spec_helper'

RSpec.describe "Api::V1::Organizations", type: :request do
  include RequestSpecHelper

  describe "GET /api/v1/organizations" do
    let!(:organizations) { create_list(:organization, 3) }

    it "lists all organizations" do
      get api_v1_organizations_path
      expect(json_body.size).to eq(3)
    end
  end

  describe "POST /api/v1/organizations" do
    context 'when params are valid' do
      let(:organization_params) { attributes_for(:organization) }

      it "returns status 201" do
        post api_v1_organizations_path, params: { organization: organization_params }
        expect(response).to have_http_status(201)
      end

      it "returns the created organization" do
        post api_v1_organizations_path, params: { organization: organization_params }
        expect(json_body[:name]).to eq(organization_params[:name])
      end
    end

    context 'when params are invalid' do
      let(:organization_params) { { name: nil } }

      it "returns status 422" do
        post api_v1_organizations_path, params: { organization: organization_params }
        expect(response).to have_http_status(422)
      end

      it "returns errors" do
        post api_v1_organizations_path, params: { organization: organization_params }
        expect(json_body).to include(:errors)
      end
    end

  end
end
