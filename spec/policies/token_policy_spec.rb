# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TokenPolicy do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:policy) { described_class.new nil, nil }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  it { is_expected.to permit_action :create }
  it { is_expected.to permit_action :destroy }
end
