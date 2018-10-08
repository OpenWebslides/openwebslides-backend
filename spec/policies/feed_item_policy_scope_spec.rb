# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedItemPolicy::Scope do
  subject { described_class.new(user, FeedItem).resolve.count }

  let(:owner) { create :user }

  before do
    d1 = create :topic
    d2 = create :topic, :user => owner
    d3 = create :topic, :state => :protected_access
    d4 = create :topic, :state => :private_access
    d5 = create :topic, :state => :private_access, :user => owner

    create :feed_item, :topic => d1, :user => d1.user
    create :feed_item, :topic => d2, :user => d2.user
    create :feed_item, :topic => d3, :user => d3.user
    create :feed_item, :topic => d4, :user => d4.user
    create :feed_item, :topic => d5, :user => d5.user
  end

  context 'when the user is a guest' do
    let(:user) { nil }

    it { is_expected.to eq 2 }
  end

  context 'when the user is a user' do
    let(:user) { create :user }

    it { is_expected.to eq 3 }
  end

  context 'when the user is an owner' do
    let(:user) { owner }

    it { is_expected.to eq 4 }
  end
end
