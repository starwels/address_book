class Organization < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, presence: true

  def contacts
    Contact.list_by(:organization_id, id)
  end
end
