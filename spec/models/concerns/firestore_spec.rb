require 'rails_helper'
require "google/cloud/firestore"

RSpec.describe Firestore do
  let(:model) do
    Model.new(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      phone: Faker::PhoneNumber.phone_number,
      organization_id: Faker::Number.number
    )
  end

  let(:expected_response) do
    {
      id: model.id,
      name: model.name,
      email: model.email,
      phone: model.phone,
      organization_id: model.organization_id
    }
  end

  before do
    allow(Model).to receive(:collection_name).and_return('testing')
  end

  after(:each) do
    models = Model.list_by(:organization_id, model.organization_id)
    models.each do |model|
      model_document = Model.find(model[:id])
      model_document.delete
    end
  end

  describe ".find" do
    context "when document exists" do
      before do
        model.save
      end

      it "returns the correct document" do
        expect(Model.find(model.id)).to be_instance_of(Model)
      end

      it "returns document with correct id" do
        model_response = Model.find(model.id)
        expect(model_response.id).to eq(model.id)
      end
    end

    context "when document does not exist" do
      it "returns the correct document" do
        expect(Model.find(-1)).to be_nil
      end
    end
  end

  describe ".list_by" do
    let(:model2) do
      Model.new(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        phone: Faker::PhoneNumber.phone_number,
        organization_id: model.organization_id,
      )
    end

    before do
      model.save
      model2.save
    end

    after do
      model2.delete
    end

    it "returns the correct size of the models by organization" do
      expect(Model.list_by(:organization_id, model.organization_id).size).to eq(2)
    end
  end

  describe "#delete" do
    before do
      model.save
    end

    it 'deletes the model' do
      object = Model.find(model.id)

      expect(object.delete).to_not be_nil
    end
  end

  describe "#update" do
    let(:params) { attributes_for(:contact) }
    let(:expected_response) do
      {
        id: model.id,
        name: params[:name],
        email: params[:email],
        phone: params[:phone],
        organization_id: params[:organization_id]
      }
    end

    before do
      model.save
    end

    it 'updates the model and returns the updated model' do
      object = Model.find(model.id)
      expect(object.update(params)).to be_truthy
    end

    it 'returns correct instance variables' do
      object = Model.find(model.id)
      object.update(params)

      expect(object.attributes).to match(expected_response)
    end
  end

  describe "#save" do
    it 'saves model and returns the saved model' do
      expect(model.save).to match(expected_response)
    end
  end

  describe ".new" do
    let(:valid_params) do
      {
        id: Faker::Number.number,
        name: Faker::Name.name,
        email: Faker::Internet.email,
        phone: Faker::PhoneNumber.phone_number,
        organization_id: model.organization_id,
      }
    end

    let(:invalid_params) do
      {
        surname: Faker::Name.name,
      }
    end

    context "when valid params" do
      it 'returns the instance' do
        expect(Model.new(valid_params)).to be_instance_of(Model)
      end
    end

    context "when invalid params" do
      it 'returns exception' do
        expect { Model.new(invalid_params) }.to raise_error(ActiveModel::UnknownAttributeError)
      end
    end
  end
end

class Model
  include Firestore

  validates :email, presence: true
  validates :name, presence: true
  validates :organization_id, presence: true

  firestore_attributes :id, :name, :email, :phone, :organization_id
end