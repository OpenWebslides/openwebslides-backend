# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:policy) { described_class.new user, record }

  ##
  # Test variables
  #
  let(:user) { create :user }
  let(:record) { 'record' }

  ##
  # Tests
  #
  it { is_expected.to have_attributes :user => user, :record => record }
end
