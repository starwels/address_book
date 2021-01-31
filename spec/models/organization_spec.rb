require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:organization) { build(:organization) }

  it "is not valid without a name" do
    organization.name = nil

    expect(organization).to_not be_valid
  end

  it "is valid with valid attributes" do
    expect(organization).to be_valid
  end
end
