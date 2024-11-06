class Address < ApplicationRecord
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :country, presence: true
  validates :organization_id, presence: true
  belongs_to :organization
end