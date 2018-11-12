# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequest, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  let(:subject) { create :pull_request }

  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'attributes' do
    it { is_expected.to validate_presence_of(:message) }

    it { is_expected.to allow_values(nil, '', 'foo').for(:feedback) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:source).class_name('Topic').inverse_of(:outgoing_pull_requests) }
    it { is_expected.to belong_to(:target).class_name('Topic').inverse_of(:incoming_pull_requests) }
  end

  describe 'state machine' do
    it { is_expected.to have_states :open, :accepted, :rejected }

    context 'when the pull request is open' do
      it { is_expected.to handle_events :accept, :reject, :when => :open }

      it { is_expected.to transition_from :open, :to_state => :accepted, :on_event => :accept }
      it { is_expected.to transition_from :open, :to_state => :rejected, :on_event => :reject }
    end

    context 'when the pull request is accepted' do
      it { is_expected.to reject_events :accept, :reject, :when => :accepted }
    end

    context 'when the pull request is rejected' do
      it { is_expected.to reject_events :accept, :reject, :when => :rejected }
    end
  end

  describe 'methods' do
    describe '#closed?' do
      context 'when the pull request is open' do
        it { is_expected.not_to be_closed }
      end

      context 'when the pull request is accepted' do
        before { subject.accept }
        it { is_expected.to be_closed }
      end

      context 'when the pull request is rejected' do
        before { subject.reject }
        it { is_expected.to be_closed }
      end
    end
  end
end