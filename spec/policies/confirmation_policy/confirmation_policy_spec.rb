# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConfirmationPolicy do
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
  it { is_expected.to permit_action :update }
end
