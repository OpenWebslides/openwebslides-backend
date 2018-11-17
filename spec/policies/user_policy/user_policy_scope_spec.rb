# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy::Scope do
  ##
  # Configuration
  #
  include_context 'policy_sample'

  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:scope) { described_class.new(user, User).resolve }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  context 'when resolving all users' do
    let(:user) { nil }

    it { is_expected.to eq User.all }
  end
end
