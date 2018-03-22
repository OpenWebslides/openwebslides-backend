# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TopicPolicy::Scope do
  context 'all topics' do
    subject { described_class.new(user, Topic).resolve }

    include_context 'policy_sample'

    context 'for a guest' do
      let(:user) { nil }

      it 'should show all public topics' do
        expect(subject.pluck :title).to match_array %w[u1d1 u2d1 u3d1 u4d1]
      end
    end

    context 'for user 1' do
      let(:user) { User.find_by :first_name => 'user1' }

      it 'should show public, protected, owned and collaborated topics' do
        expect(subject.pluck :title).to match_array %w[u1d1 u1d2 u1d3 u1d4 u2d1 u2d2 u2d4 u3d1 u3d2 u3d4 u4d1 u4d2]
      end
    end

    context 'for user 2' do
      let(:user) { User.find_by :first_name => 'user2' }

      it 'should show public, protected, owned and collaborated topics' do
        expect(subject.pluck :title).to match_array %w[u1d1 u1d2 u1d4 u2d1 u2d2 u2d3 u2d4 u3d1 u3d2 u3d4 u4d1 u4d2]
      end
    end

    context 'for user 3' do
      let(:user) { User.find_by :first_name => 'user3' }

      it 'should show public, protected, owned and collaborated topics' do
        expect(subject.pluck :title).to match_array %w[u1d1 u1d2 u1d4 u2d1 u2d2 u2d4 u3d1 u3d2 u3d3 u3d4 u4d1 u4d2]
      end
    end

    context 'for user 4' do
      let(:user) { User.find_by :first_name => 'user4' }

      it 'should show public, protected, owned and collaborated topics' do
        expect(subject.pluck :title).to match_array %w[u1d1 u1d2 u2d1 u2d2 u3d1 u3d2 u4d1 u4d2 u4d3]
      end
    end
  end

  context 'a users topics' do
    subject { described_class.new(user, User.find_by(:first_name => 'user1').topics).resolve }

    include_context 'policy_sample'

    context 'for a guest' do
      let(:user) { nil }

      it 'should show all public topics' do
        expect(subject.pluck :title).to match_array %w[u1d1]
      end
    end

    context 'for user 1' do
      let(:user) { User.find_by :first_name => 'user1' }

      it 'should show public, protected, owned and collaborated topics' do
        expect(subject.pluck :title).to match_array %w[u1d1 u1d2 u1d3 u1d4]
      end
    end

    context 'for user 2' do
      let(:user) { User.find_by :first_name => 'user2' }

      it 'should show public, protected and collaborated topics' do
        expect(subject.pluck :title).to match_array %w[u1d1 u1d2 u1d4]
      end
    end

    context 'for user 3' do
      let(:user) { User.find_by :first_name => 'user3' }

      it 'should show public, protected and collaborated topics' do
        expect(subject.pluck :title).to match_array %w[u1d1 u1d2 u1d4]
      end
    end

    context 'for user 4' do
      let(:user) { User.find_by :first_name => 'user4' }

      it 'should show public, protected and collaborated topics' do
        expect(subject.pluck :title).to match_array %w[u1d1 u1d2]
      end
    end
  end
end
