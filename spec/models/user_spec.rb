require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { build(:user, :with_organization) }

  it "is not valid without an email" do
    user.email = nil

    expect(user).to_not be_valid
  end

  it "is not valid without at least one organization" do
    user.organizations = []

    expect(user).to_not be_valid
  end

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end
end
