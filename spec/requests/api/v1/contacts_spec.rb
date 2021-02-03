require 'rails_helper'
require 'support/request_spec_helper'

RSpec.describe "Contacts", type: :request do
  include RequestSpecHelper

  after(:each) do
    contacts = Contact.list_by_association_id(organization.id)
    contacts.each do |contact|
      contact_document = Contact.find_document(contact[:id])
      contact_document.delete
    end
  end

  let(:user) { create(:user, organizations: [organization]) }
  let(:organization) { create(:organization) }
  let(:headers) { { 'Authorization' => token_generator(user) } }

  before do
    allow(Contact).to receive(:collection_name).and_return('testing')
  end

  describe "GET /api/v1/contacts" do
    let!(:contacts) do
      2.times do
        contact = Contact.new(attributes_for(:contact, organization_id: organization.id))
        contact.save
      end
    end

    it "lists all contacts" do
      get api_v1_contacts_path, headers: headers, params: { organization_id: organization.id }
      expect(json_body[:contacts].size).to eq(2)
    end
  end

  describe "POST /api/v1/contacts" do
    context 'when params are valid' do
      let(:contact_params) { attributes_for(:contact, organization_id: organization.id) }

      it "returns status 201" do
        post api_v1_contacts_path, headers: headers, params: { contact: contact_params }
        expect(response).to have_http_status(201)
      end

      it "returns the created contact" do
        post api_v1_contacts_path, headers: headers, params: { contact: contact_params }
        expect(json_body[:contact][:name]).to eq(contact_params[:name])
      end
    end

    context 'when params are invalid' do
      let(:contact_params) { { name: nil, organization_id: organization.id } }

      it "returns status 422" do
        post api_v1_contacts_path, headers: headers, params: { contact: contact_params }
        expect(response).to have_http_status(422)
      end

      it "returns errors" do
        post api_v1_contacts_path, headers: headers, params: { contact: contact_params }
        expect(json_body).to include(:errors)
      end
    end
  end

  describe "PUT /api/v1/contact/:id" do
    let(:contact) do
      contact = Contact.new(attributes_for(:contact, organization_id: organization.id))
      contact.save
      contact
    end

    context 'when params are valid' do
      let(:contact_params) { attributes_for(:contact, organization_id: organization.id) }

      it "returns status 200" do
        put api_v1_contact_path(contact.id), headers: headers, params: { contact: contact_params }
        expect(response).to have_http_status(200)
      end

      it "returns the updated contact" do
        put api_v1_contact_path(contact.id), headers: headers, params: { contact: contact_params }
        expect(json_body[:contact][:name]).to eq(contact_params[:name])
      end
    end

    context 'when params are invalid' do
      let(:contact_params) { { name: nil, organization_id: organization.id } }

      it "returns status 422" do
        put api_v1_contact_path(contact.id), headers: headers, params: { contact: contact_params }
        expect(response).to have_http_status(422)
      end

      it "returns errors" do
        put api_v1_contact_path(contact.id), headers: headers, params: { contact: contact_params }
        expect(json_body).to include(:errors)
      end
    end
  end

  describe "DELETE /api/v1/contact/:id" do
    context "when user belongs to organization" do
      let(:contact) do
        contact = Contact.new(attributes_for(:contact, organization_id: organization.id))
        contact.save
        contact
      end

      it "returns status 204" do
        delete api_v1_contact_path(contact.id), headers: headers
        expect(response).to have_http_status(204)
      end
    end

    context "when user does not belong to organization" do
      let(:organization2) { create(:organization) }
      let(:contact) do
        contact = Contact.new(attributes_for(:contact, organization_id: organization2.id))
        contact.save
        contact
      end

      after do
        contact.delete
      end

      it "returns status 401" do
        delete api_v1_contact_path(contact.id), headers: headers
        expect(response).to have_http_status(401)
      end
    end

    context "when contact does not exist" do
      let(:contact) do
        contact = Contact.new(attributes_for(:contact, organization_id: organization.id))
        contact.save
        contact
      end

      it "returns status 204" do
        delete api_v1_contact_path(contact.id + 1.to_s), headers: headers
        expect(response).to have_http_status(204)
      end
    end
  end
end
