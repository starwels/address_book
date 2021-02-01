class User < ApplicationRecord
  has_secure_password

  has_and_belongs_to_many :organizations

  validates :email, presence: true
  validates :organizations, presence: true

  enum role: { user: 0, admin: 1 }

  def admin?
    role.eql?('admin')
  end
end
