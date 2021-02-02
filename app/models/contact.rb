class Contact
  include Firestore

  validates :email, presence: true
  validates :name, presence: true
  validates :organization_id, presence: true

  attr_accessor :id, :name, :email, :phone, :organization_id

  belongs_to :organization
end