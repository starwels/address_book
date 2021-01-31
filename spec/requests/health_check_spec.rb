require 'rails_helper'

RSpec.describe "HealthChecks", type: :request do
  describe "GET /" do
    context "when client requests html" do
      it "should return proper message" do
        get root_path
        expect(response.body).to eq("I am up and running!")
      end
    end

    context "when client requests json" do
      it "should return proper message" do
        get root_path, headers: { "Accept": "application/json" }
        expect(response.body).to eq("I am up and running!")
      end
    end
  end
end
