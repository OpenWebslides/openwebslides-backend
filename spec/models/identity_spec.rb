# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Identity, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:identity) { build :identity }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'attributes' do
    it { is_expected.to validate_presence_of :uid }
    it { is_expected.to validate_presence_of :provider }
    it { is_expected.to validate_uniqueness_of(:uid).scoped_to :provider }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
