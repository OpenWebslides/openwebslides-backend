# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alert, :type => :model do
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

  describe 'attributes' do
    it { is_expected.to allow_values(false, 'false', true, 'true').for :read }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of :alerts }
  end
end
