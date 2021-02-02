require "google/cloud/firestore"

module Firestore
  extend ActiveSupport::Concern
  include ActiveModel::Validations
  include Google::Cloud::Firestore

  def self.included(base)
    base.extend(ClassMethods)
  end

  def to_json
    {
      id: @id,
      name: @name,
      email: @email,
      phone: @phone,
      organization_id: @organization_id
    }
  end

  def get
    doc = @document.get

    if doc.data
      response_to_accessors
      return_response
    end
  end

  def save
    if valid?
      doc_ref = self.class.firestore.col(self.class.collection_name)
      @document = doc_ref.add({ email: @email, name: @name, phone: @phone, organization_id: @organization_id.to_i })

      response_to_accessors
      return_response
    end
  end

  def update(attributes =  {})
    attributes.each do |key, value|
      instance_variable_set(:"@#{key}", value)
    end

    if self.class.belongs_to_klass
      association_name = self.class.belongs_to_klass
      attributes[:"#{association_name}_id"] = attributes[:"#{association_name}_id"].to_i
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
    attributes.each do |key, value|
      instance_variable_set(:"@#{key}", value)
    end
  end

  module ClassMethods
    def belongs_to(klass)
      @belongs_to_klass ||= klass
    end

    def belongs_to_klass
      @belongs_to_klass
    end

    def collection_name
      @collection_name ||= self.name.pluralize.downcase
    end

    def list_by_association_id(id)
      query = firestore.col(collection_name).where("#{@belongs_to_klass}_id".to_sym, :==, id)
      resources = []
      query.get do |resource|
        resources.push({ id: resource.document_id }.merge(resource.data))
      end

      resources
    end

    def find_document(id)
      document = firestore.doc("#{collection_name}/#{id}")
      if document.get.data
        new({id: document.document_id, document: document}.merge(document.get.data))
      end
    end

    def firestore
      @firestore ||= Google::Cloud::Firestore.new(project_id: ENV['PROJECT_ID'])
    end
  end

  def response_to_accessors
    document_data = @document.get.data

    @id ||= @document.document_id
    @name ||= document_data[:name]
    @email ||= document_data[:email]
    @phone ||= document_data[:phone]
    @organization_id ||= document_data[:organization_id]
  end

  private :response_to_accessors

  def return_response
    response = {
      id: @document.document_id,
    }

    response.merge(@document.get.data)
  end

  private :return_response
end