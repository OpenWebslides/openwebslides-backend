# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  subject(:alert) { create :alert }

  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of :alerts }
  end
end
