# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationPolicy::Scope do
  subject { described_class.new(user, Notification).resolve.count }

  let(:owner) { create :user }

  before :each do
    d1 = create :topic
    d2 = create :topic, :user => owner
    d3 = create :topic, :state => :protected_access
    d4 = create :topic, :state => :private_access
    d5 = create :topic, :state => :private_access, :user => owner

    create :notification, :topic => d1, :user => d1.user
    create :notification, :topic => d2, :user => d2.user
    create :notification, :topic => d3, :user => d3.user
    create :notification, :topic => d4, :user => d4.user
    create :notification, :topic => d5, :user => d5.user
  end

  context 'for a guest' do
    let(:user) { nil }

    it { is_expected.to eq 2 }
  end

  context 'for a user' do
    let(:user) { create :user }

    it { is_expected.to eq 3 }
  end

  context 'for an owner' do
    let(:user) { owner }

    it { is_expected.to eq 4 }
  end
end
