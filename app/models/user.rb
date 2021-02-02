class User < ApplicationRecord
  has_secure_password

  has_and_belongs_to_many :organizations

  validates :email, presence: true, uniqueness: true
  validates :organizations, presence: true
  validates :password, length: { in: 6..20 }

  enum role: { user: 0, admin: 1 }

  def admin?
    role.eql?('admin')
  end
end
