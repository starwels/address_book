require 'rails_helper'
require 'support/request_spec_helper'

RSpec.describe "Api::V1::Authentications", type: :request do
  include RequestSpecHelper

  describe "POST /api/v1/authentications" do
    let(:user) { create(:user, :with_organization) }

    context 'when params are valid' do
      let(:authentication_params) do
        {
          authentication: {
            email: user.email,
            password: user.password,
          }
        }
      end

      it "returns status 201" do
        post api_v1_authentications_path, params: authentication_params
        expect(response).to have_http_status(201)
      end

      it "returns the user token" do
        post api_v1_authentications_path, params: authentication_params
        expect(json_body[:token]).to eq(token_generator(user))
      end
    end

    context 'when params are invalid' do
      let(:authentication_params) do
        {
          authentication: {
            email: user.email,
            password: "#{user.password}123",
          }
        }
      end

      it "returns status 401" do
        post api_v1_authentications_path, headers: headers, params: authentication_params
        expect(response).to have_http_status(401)
      end
    end
  end
end
