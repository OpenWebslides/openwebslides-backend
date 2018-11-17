# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy::Scope do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:scope) { described_class.new user, 'scope' }

  ##
  # Test variables
  #
  let(:user) { build :user }

  ##
  # Tests
  #
  #
  it { is_expected.to have_attributes :user => user, :scope => 'scope'}

  describe '.resolve' do
    it 'raises NotImplementedError' do
      expect { scope.resolve }.to raise_error OpenWebslides::NotImplementedError
    end
  end
end
