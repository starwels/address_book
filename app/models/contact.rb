class Contact
  include Firestore

  validates :email, presence: true
  validates :name, presence: true
  validates :organization_id, presence: true

  firestore_attributes :id, :name, :email, :phone, :organization_id
end