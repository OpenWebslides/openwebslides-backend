# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TopicPolicy::Scope do
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
  subject(:scope) { described_class.new(user, Alert).resolve.pluck :title }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  context 'when resolving all topics' do
    subject(:scope) { described_class.new(user, Topic).resolve.pluck :title }

    context 'when the user is a guest' do
      let(:user) { nil }

      # All public topic
      it { is_expected.to match_array %w[u1d1 u2d1 u3d1 u4d1] }
    end

    context 'when the user is user 1' do
      let(:user) { User.find_by :name => 'user1' }

      # Public, protected, owned and collaborated topics
      it { is_expected.to match_array %w[u1d1 u1d2 u1d3 u1d4 u2d1 u2d2 u2d4 u3d1 u3d2 u3d4 u4d1 u4d2] }
    end

    context 'when the user is user 2' do
      let(:user) { User.find_by :name => 'user2' }

      # Public, protected, owned and collaborated topics
      it { is_expected.to match_array %w[u1d1 u1d2 u1d4 u2d1 u2d2 u2d3 u2d4 u3d1 u3d2 u3d4 u4d1 u4d2] }
    end

    context 'when the user is user 3' do
      let(:user) { User.find_by :name => 'user3' }

      # Public, protected, owned and collaborated topics
      it { is_expected.to match_array %w[u1d1 u1d2 u1d4 u2d1 u2d2 u2d4 u3d1 u3d2 u3d3 u3d4 u4d1 u4d2] }
    end

    context 'when the user is user 4' do
      let(:user) { User.find_by :name => 'user4' }

      # Public, protected, owned and collaborated topics
      it { is_expected.to match_array %w[u1d1 u1d2 u2d1 u2d2 u3d1 u3d2 u4d1 u4d2 u4d3] }
    end
  end

  context 'when resolving a users topics' do
    subject(:scope) { described_class.new(user, User.find_by(:name => 'user1').topics).resolve.pluck :title }

    context 'when the user is a guest' do
      let(:user) { nil }

      # All public topics
      it { is_expected.to match_array %w[u1d1] }
    end

    context 'when the user is user 1' do
      let(:user) { User.find_by :name => 'user1' }

      # Public, protected, owned and collaborated topics
      it { is_expected.to match_array %w[u1d1 u1d2 u1d3 u1d4] }
    end

    context 'when the user is user 2' do
      let(:user) { User.find_by :name => 'user2' }

      # Public, protected and collaborated topics
      it { is_expected.to match_array %w[u1d1 u1d2 u1d4] }
    end

    context 'when the user is user 3' do
      let(:user) { User.find_by :name => 'user3' }

      # Public, protected and collaborated topics
      it { is_expected.to match_array %w[u1d1 u1d2 u1d4] }
    end

    context 'when the user is user 4' do
      let(:user) { User.find_by :name => 'user4' }

      # Public, protected and collaborated topics
      it { is_expected.to match_array %w[u1d1 u1d2] }
    end
  end
end
