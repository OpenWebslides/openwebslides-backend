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
  # Subject
  #
  subject(:pull_request) { create :pull_request }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'attributes' do
    it { is_expected.to validate_presence_of(:message) }

    context 'when the PR is pending' do
      before { subject.update :state => 'pending' }

      it { is_expected.to validate_absence_of :feedback }
    end

    context 'when the PR is incompatible' do
      before { subject.update :state => 'incompatible' }

      it { is_expected.to validate_absence_of :feedback }
    end

    context 'when the PR is open' do
      before { subject.update :state => 'open' }

      it { is_expected.to validate_absence_of :feedback }
    end

    context 'when the PR is accepted' do
      before { subject.update :state => 'accepted' }

      it { is_expected.not_to validate_presence_of :feedback }
    end

    context 'when the PR is rejected' do
      before { subject.update :state => 'rejected' }

      it { is_expected.to validate_presence_of :feedback }
    end

    describe 'feedback can only be updated on state change' do
      context 'from `open` to `open`' do
        subject { create :pull_request, :state => 'open' }

        it 'rejects update on feedback' do
          expect { subject.update! :feedback => 'feedback' }.to raise_error ActiveRecord::RecordInvalid
        end
      end

      context 'from `open` to `accepted`' do
        subject { create :pull_request, :state => 'open' }

        it 'accepts update on feedback' do
          expect { subject.update! :state_event => 'accept', :feedback => 'feedback' }.not_to raise_error
        end
      end

      context 'from `open` to `rejected`' do
        subject { create :pull_request, :state => 'open' }

        it 'accepts update on feedback' do
          expect { subject.update! :state_event => 'reject', :feedback => 'feedback' }.not_to raise_error
        end
      end

      context 'from `accepted` to `accepted`' do
        subject { create :pull_request, :state => 'accepted', :feedback => 'feedback' }

        it 'rejects update on feedback' do
          expect { subject.update! :feedback => 'feedback update' }.to raise_error ActiveRecord::RecordInvalid
        end
      end

      context 'from `rejected` to `rejected`' do
        subject { create :pull_request, :state => 'rejected', :feedback => 'feedback' }

        it 'rejects update on feedback' do
          expect { subject.update! :feedback => 'feedback update' }.to raise_error ActiveRecord::RecordInvalid
        end
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:source).class_name('Topic').inverse_of(:outgoing_pull_requests) }
    it { is_expected.to belong_to(:target).class_name('Topic').inverse_of(:incoming_pull_requests) }

    context 'when source does not have an upstream' do
      let(:subject) { build :pull_request, :source => build(:topic) }

      it { is_expected.not_to be_valid }
    end

    context 'when source has an upstream not equal to the target' do
      let(:subject) { build :pull_request, :source => build(:topic, :upstream => create(:topic)) }

      it { is_expected.not_to be_valid }
    end

    context 'when source already has a pending pull request' do
      let(:pull_request) { create :pull_request, :state => 'pending' }
      let(:subject) { build :pull_request, :source => pull_request.source, :target => pull_request.target }

      # Reload source topic to refetch associations
      before { pull_request.source.reload }

      it { is_expected.not_to be_valid }
    end

    context 'when source already has an open pull request' do
      let(:pull_request) { create :pull_request, :state => 'open' }
      let(:subject) { build :pull_request, :source => pull_request.source, :target => pull_request.target }

      # Reload source topic to refetch associations
      before { pull_request.source.reload }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'state machine' do
    it { is_expected.to have_states :pending, :open, :accepted, :rejected }

    context 'when the pull request is pending' do
      it { is_expected.to reject_events :accept, :reject, :when => :pending }
    end

    context 'when the pull request is incompatible' do
      it { is_expected.to reject_events :accept, :reject, :when => :incompatible }
    end

    context 'when the pull request is open' do
      # Rejection needs feedback
      before { subject.feedback = 'feedback' }

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
      context 'when the pull request is pending' do
        before { subject.update :state => 'pending' }

        it { is_expected.not_to be_closed }
      end

      context 'when the pull request is incompatible' do
        before { subject.update :state => 'incompatible' }

        it { is_expected.to be_closed }
      end

      context 'when the pull request is open' do
        before { subject.update :state => 'open' }

        it { is_expected.not_to be_closed }
      end

      context 'when the pull request is accepted' do
        before { subject.update :state => 'accepted' }

        it { is_expected.to be_closed }
      end

      context 'when the pull request is rejected' do
        before { subject.update :state => 'rejected' }

        it { is_expected.to be_closed }
      end
    end
  end
end
