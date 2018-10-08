# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConversationPolicy::Scope do
  subject { described_class.new(user, Conversation).resolve }

  it 'inherits AnnotationPolicy' do
    expect(described_class).to be < AnnotationPolicy::Scope
  end

  include_context 'policy_sample'

  context 'when the user is a guest' do
    let(:user) { nil }

    it 'shows annotations of all public topics' do
      expect(subject.count).to eq 12
    end
  end

  context 'when the user is user 1' do
    let(:user) { User.find_by :name => 'user1' }

    it 'shows annotations of public, protected, owned and collaborated topics' do
      expect(subject.count).to eq 36
    end
  end

  context 'when the user is user 2' do
    let(:user) { User.find_by :name => 'user2' }

    it 'shows annotations of public, protected, owned and collaborated topics' do
      expect(subject.count).to eq 36
    end
  end

  context 'when the user is user 3' do
    let(:user) { User.find_by :name => 'user3' }

    it 'shows annotations of public, protected, owned and collaborated topics' do
      expect(subject.count).to eq 36
    end
  end

  context 'when the user is user 4' do
    let(:user) { User.find_by :name => 'user4' }

    it 'shows annotations of public, protected, owned and collaborated topics' do
      expect(subject.count).to eq 27
    end
  end
end
