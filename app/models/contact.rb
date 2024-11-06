class Contact
  include Firestore
  validates :email, presence: true
  validates :name, presence: true
  validates :business_id, presence: true
  attr_accessor :id, :name, :email, :phone, :business_id
  belongs_to :business
end