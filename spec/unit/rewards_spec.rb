# frozen_string_literal: true

# location: spec/unit/unit_spec.rb
require 'rails_helper'

# Attributes:
# string "name"
# integer "point_value"
# decimal "dollar_price"
# integer "inventory"

RSpec.describe(Reward, type: :model) do
  subject(:reward) do
    described_class.new(
      name: 'test reward',
      point_value: 10,
      dollar_price: 19.99,
      inventory: 100
    )
  end

  it 'is valid with valid attributes' do
    expect(reward).to(be_valid)
  end

  it 'is not valid without a name' do
    reward.name = nil
    expect(reward).not_to(be_valid)
  end

  it 'is not valid without a point value' do
    reward.point_value = nil
    expect(reward).not_to(be_valid)
  end

  it 'is not valid with a negative point value' do
    reward.point_value = -10
    expect(reward).not_to(be_valid)
  end

  it 'is not valid with an extremely large point value' do
    reward.point_value = 10_000_000_000
    expect(reward).not_to(be_valid)
  end

  it 'is not valid without a dollar price' do
    reward.dollar_price = nil
    expect(reward).not_to(be_valid)
  end

  it 'is not valid with a negative dollar price' do
    reward.dollar_price = -1.99
    expect(reward).not_to(be_valid)
  end

  it 'is not valid with an extremely large dollar price' do
    reward.dollar_price = 10_000_000_000
    expect(reward).not_to(be_valid)
  end

  it 'is not valid without an inventory' do
    reward.inventory = nil
    expect(reward).not_to(be_valid)
  end

  it 'is not valid with a negative inventory' do
    reward.inventory = -200
    expect(reward).not_to(be_valid)
  end

  it 'is not valid with an extremely large inventory' do
    reward.inventory = 10_000_000_000
    expect(reward).not_to(be_valid)
  end
end
