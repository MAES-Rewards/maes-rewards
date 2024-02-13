# frozen_string_literal: true

require 'rails_helper'

# Attributes:
# string "name"
# string "description"
# integer "default_points"

RSpec.describe(Activity, type: :model) do
  subject(:activity) do
    described_class.new(
      name: 'Test Activity',
      description: 'Test Description',
      default_points: 100
    )
  end

  it 'is valid with valid attributes' do
    expect(activity).to(be_valid)
  end

  it 'is not valid without a name' do
    activity.name = nil
    expect(activity).not_to(be_valid)
  end

  it 'is not valid without a description' do
    activity.description = nil
    expect(activity).not_to(be_valid)
  end

  it 'is not valid without a default point value' do
    activity.default_points = nil
    expect(activity).not_to(be_valid)
  end

  it 'is not valid with a negative default point value' do
    activity.default_points = -10
    expect(activity).not_to(be_valid)
  end

  it 'is not valid with an extremely large default point value' do
    activity.default_points = 10_000_000_000
    expect(activity).not_to(be_valid)
  end
end
