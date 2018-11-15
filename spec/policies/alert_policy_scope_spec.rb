# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlertPolicy::Scope do
  subject { described_class.new(user, Alert).resolve.count }

  let(:user1) { create :user }
  let(:user2) { create :user }

  before :each do
    create_list :update_alert, 3, :user => user1
    create_list :update_alert, 5, :user => user2
  end

  context 'when the user is a guest' do
    let(:user) { nil }

    it { is_expected.to eq 0 }
  end

  context 'when the user is a user' do
    let(:user) { create :user }

    it { is_expected.to eq 0 }
  end

  context 'when the user is the same' do
    let(:user) { user1 }

    it { is_expected.to eq 3 }
  end
end
