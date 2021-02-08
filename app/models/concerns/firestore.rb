require "google/cloud/firestore"

module Firestore
  extend ActiveSupport::Concern

  include ActiveModel::Validations
  include ActiveModel::AttributeAssignment

  include Google::Cloud::Firestore

  def self.included(base)
    base.extend(ClassMethods)
  end

  def attributes
    self.class.instance_attributes.each_with_object({}) do |attribute, obj|
      obj[:"#{attribute}"] = instance_variable_get("@#{attribute}")
    end
  end

  def to_h
    attributes
  end

  def save
    if valid?
      doc_ref = self.class.firestore.col(self.class.collection_name)
      @document = doc_ref.add(attributes.except(:id))

      response_to_accessors
      return_response
    end
  end

  def update(attributes =  {})
    attributes = attributes.to_h.symbolize_keys

    self.class.instance_attributes.each do |attribute|
      instance_variable_set("@#{attribute}", attributes[attribute])
    end

    if valid?
      @document.set(attributes.to_h, merge: true)

      response_to_accessors
      return_response
    end
  end

  def delete
    begin
      @document.delete(exists: true)
    rescue Google::Cloud::NotFoundError
      nil
    end
  end

  def initialize(attributes = {})
    assign_attributes(attributes)
  end

  module ClassMethods
    attr_reader :instance_attributes

    def firestore_attributes(*attributes)
      @instance_attributes = attributes
      send(:attr_accessor, *attributes)
    end

    def collection_name
      if Rails.env.development?
        @collection_name ||= 'dev'
      else
        @collection_name ||= self.name.pluralize.downcase
      end
    end

    def list_by(attribute, value)
      query = firestore.col(collection_name).where(attribute.to_sym, :==, value)
      resources = []
      query.get do |resource|
        resources.push({ id: resource.document_id }.merge(resource.data))
      end

      resources
    end

    def find(id)
      document = firestore.doc("#{collection_name}/#{id}")
      if document.get.data
        object = new({id: document.document_id}.merge(document.get.data))
        object.instance_variable_set(:@document, document)
        object
      end
    end

    def firestore
      @firestore ||= Google::Cloud::Firestore.new(project_id: ENV['PROJECT_ID'])
    end
  end

  private

  def response_to_accessors
    document_data = @document.get.data

    assign_attributes(document_data)
    assign_attributes(id: @document.document_id)
  end

  def return_response
    response = {
      id: @document.document_id,
    }

    response.merge(@document.get.data)
  end
end