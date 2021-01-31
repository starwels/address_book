require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it "is not valid without an email" do
    user.email = nil

    expect(user).to_not be_valid
  end

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end
end
