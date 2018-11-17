# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssetPolicy::Scope do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:scope) { described_class.new(user, Asset).resolve.count }

  ##
  # Test variables
  #
  include_context 'policy_sample'

  ##
  # Tests
  #
  context 'when the user is a guest' do
    let(:user) { nil }

    # Assets of all public topics
    it { is_expected.to eq 12 }
  end

  context 'when the user is user 1' do
    let(:user) { User.find_by :name => 'user1' }

    # Assets of public, protected, owned and collaborated topics
    it { is_expected.to eq 36 }
  end

  context 'when the user is user 2' do
    let(:user) { User.find_by :name => 'user2' }

    # Assets of public, protected, owned and collaborated topics
    it { is_expected.to eq 36 }
  end

  context 'when the user is user 3' do
    let(:user) { User.find_by :name => 'user3' }

    # Assets of public, protected, owned and collaborated topics
    it { is_expected.to eq 36 }
  end

  context 'when the user is user 4' do
    let(:user) { User.find_by :name => 'user4' }

    # Assets of public, protected, owned and collaborated topics
    it { is_expected.to eq 27 }
  end
end
