# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Content, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:content) { build :content }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  describe 'attributes' do
    it { is_expected.to validate_presence_of :content }
  end

  describe 'associations' do
    it { is_expected.to validate_presence_of :topic }
  end
end
