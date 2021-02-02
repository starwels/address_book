require 'rails_helper'
require "google/cloud/firestore"

RSpec.describe Organization do
  let(:contact) { build(:contact) }
  let(:expected_response) do
    {
      id: contact.id,
      name: contact.name,
      email: contact.email,
      phone: contact.phone,
      organization_id: contact.organization_id
    }
  end

  before do
    allow(Contact).to receive(:collection_name).and_return('testing')
  end

  after(:each) do
    contacts = Contact.list_by_association_id(contact.organization_id)
    contacts.each do |contact|
      contact_document = Contact.find_document(contact[:id])
      contact_document.delete
    end
  end

  describe ".find_document" do
    context "when document exists" do
      it "returns the correct document" do
        contact.save

        expect(Contact.find_document(contact.id)).to be_instance_of(Contact)
      end

      it "returns document with correct id" do
        contact.save

        contact_response = Contact.find_document(contact.id)
        expect(contact_response.id).to eq(contact.id)
      end
    end

    context "when document does not exist" do
      it "returns the correct document" do
        expect(Contact.find_document(-1)).to be_nil
      end
    end
  end

  describe ".list_by_association_id" do
    let(:contact2) { build(:contact, organization_id: contact.organization_id) }

    after do
      contact2.delete
    end

    it "returns the correct size of the contacts by organization" do
      contact.save
      contact2.save

      expect(Contact.list_by_association_id(contact.organization_id).size).to eq(2)
    end
  end

  describe "#get" do
    it "returns the correct contact" do
      contact.save

      contact_doc = Contact.find_document(contact.id)
      expect(contact_doc.get).to match(expected_response)
    end
  end

  describe "#save" do
    it 'saves contact and returns the saved contact' do
      expect(contact.save).to match(expected_response)
    end
  end

  describe "#delete" do
    it 'deletes the contact' do
      contact.save

      expect(contact.delete).to_not be_nil
    end
  end

  describe "#update" do
    let(:params) { attributes_for(:contact) }
    let(:expected_response) do
      {
        id: contact.id,
        name: params[:name],
        email: params[:email],
        phone: params[:phone],
        organization_id: params[:organization_id]
      }
    end

    it 'updates the contact and returns the updated contact' do
      contact.save

      expect(contact.update(params)).to match(expected_response)
    end
  end
end