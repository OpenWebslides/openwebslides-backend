# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnnotationPolicy::Scope do
  ##
  # Configuration
  #
  include_context 'policy_sample'

  ##
  # Stubs and mocks
  #
  ##
  # scope
  #
  subject(:scope) { described_class.new(user, Annotation).resolve.count }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  context 'when the user is a guest' do
    let(:user) { nil }

    # Annotations of all public topics
    it { is_expected.to eq 12 }
  end

  context 'when the user is user 1' do
    let(:user) { User.find_by :name => 'user1' }

    # Annotations of public, protected, owned and collaborated topics
    it { is_expected.to eq 36 }
  end

  context 'when the user is user 2' do
    let(:user) { User.find_by :name => 'user2' }

    # Annotations of public, protected, owned and collaborated topics
    it { is_expected.to eq 36 }
  end

  context 'when the user is user 3' do
    let(:user) { User.find_by :name => 'user3' }

    # Annotations of public, protected, owned and collaborated topics
    it { is_expected.to eq 36 }
  end

  context 'when the user is user 4' do
    let(:user) { User.find_by :name => 'user4' }

    # Annotations of public, protected, owned and collaborated topics
    it { is_expected.to eq 27 }
  end
end
