# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentPolicy::Scope do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:scope) { described_class.new(user, Comment).resolve.count }

  ##
  # Test variables
  #
  include_context 'policy_sample'

  ##
  # Tests
  #
  it 'inherits AnnotationPolicy' do
    expect(described_class).to be < AnnotationPolicy::Scope
  end

  context 'when the user is a guest' do
    let(:user) { nil }

    # Annotations of all topics
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
