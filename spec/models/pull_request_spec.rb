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
      before { pull_request.update :state => 'pending' }

      it { is_expected.to validate_absence_of :feedback }
    end

    context 'when the PR is incompatible' do
      before { pull_request.update :state => 'incompatible' }

      it { is_expected.to validate_absence_of :feedback }
    end

    context 'when the PR is ready' do
      before { pull_request.update :state => 'ready' }

      it { is_expected.to validate_absence_of :feedback }
    end

    context 'when the PR is accepted' do
      before { pull_request.update :state => 'accepted' }

      it { is_expected.not_to validate_presence_of :feedback }
    end

    context 'when the PR is rejected' do
      before { pull_request.update :state => 'rejected' }

      it { is_expected.to validate_presence_of :feedback }
    end

    describe 'feedback can only be updated on state change' do
      context 'when transitioning from `ready` to `ready`' do
        before { pull_request.update :state => 'ready' }

        it 'rejects update on feedback' do
          expect { pull_request.update! :feedback => 'feedback' }.to raise_error ActiveRecord::RecordInvalid
        end
      end

      context 'when transitioning from `ready` to `accepted`' do
        before { pull_request.update :state => 'ready' }

        it 'accepts update on feedback' do
          expect { pull_request.update! :state_event => 'accept', :feedback => 'feedback' }.not_to raise_error
        end
      end

      context 'when transitioning from `ready` to `rejected`' do
        before { pull_request.update :state => 'ready' }

        it 'accepts update on feedback' do
          expect { pull_request.update! :state_event => 'reject', :feedback => 'feedback' }.not_to raise_error
        end
      end

      context 'when transitioning from `accepted` to `accepted`' do
        before { pull_request.update :state => 'accepted', :feedback => 'feedback' }

        it 'rejects update on feedback' do
          expect { pull_request.update! :feedback => 'feedback update' }.to raise_error ActiveRecord::RecordInvalid
        end
      end

      context 'when transitioning from `rejected` to `rejected`' do
        before { pull_request.update :state => 'rejected', :feedback => 'feedback' }

        it 'rejects update on feedback' do
          expect { pull_request.update! :feedback => 'feedback update' }.to raise_error ActiveRecord::RecordInvalid
        end
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:source).class_name('Topic').inverse_of(:outgoing_pull_requests) }
    it { is_expected.to belong_to(:target).class_name('Topic').inverse_of(:incoming_pull_requests) }

    context 'when source does not have an upstream' do
      subject { build :pull_request, :source => build(:topic) }

      it { is_expected.not_to be_valid }
    end

    context 'when source has an upstream not equal to the target' do
      subject { build :pull_request, :source => build(:topic, :upstream => create(:topic)) }

      it { is_expected.not_to be_valid }
    end

    context 'when source already has a pending pull request' do
      subject { build :pull_request, :source => pull_request.source, :target => pull_request.target }

      before do
        pull_request.update :state => 'pending'
        pull_request.source.reload
      end

      it { is_expected.not_to be_valid }
    end

    context 'when source already has a ready pull request' do
      subject { build :pull_request, :source => pull_request.source, :target => pull_request.target }

      before do
        pull_request.update :state => 'ready'
        pull_request.source.reload
      end

      it { is_expected.not_to be_valid }
    end
  end

  describe 'state machine' do
    it { is_expected.to have_states :pending, :ready, :accepted, :rejected }

    context 'when the pull request is pending' do
      it { is_expected.to reject_events :accept, :reject, :when => :pending }
    end

    context 'when the pull request is incompatible' do
      it { is_expected.to reject_events :accept, :reject, :when => :incompatible }
    end

    context 'when the pull request is ready' do
      # Rejection needs feedback
      before { pull_request.feedback = 'feedback' }

      it { is_expected.to handle_events :accept, :reject, :when => :ready }

      it { is_expected.to transition_from :ready, :to_state => :accepted, :on_event => :accept }
      it { is_expected.to transition_from :ready, :to_state => :rejected, :on_event => :reject }
    end

    context 'when the pull request is accepted' do
      it { is_expected.to reject_events :accept, :reject, :when => :accepted }
    end

    context 'when the pull request is rejected' do
      it { is_expected.to reject_events :accept, :reject, :when => :rejected }
    end
  end

  describe 'methods' do
    describe '#closed? and #open?' do
      context 'when the pull request is pending' do
        before { pull_request.update :state => 'pending' }

        it { is_expected.not_to be_closed }
        it { is_expected.to be_open }
      end

      context 'when the pull request is incompatible' do
        before { pull_request.update :state => 'incompatible' }

        it { is_expected.to be_closed }
        it { is_expected.not_to be_open }
      end

      context 'when the pull request is ready' do
        before { pull_request.update :state => 'ready' }

        it { is_expected.not_to be_closed }
        it { is_expected.to be_open }
      end

      context 'when the pull request is accepted' do
        before { pull_request.update :state => 'accepted' }

        it { is_expected.to be_closed }
        it { is_expected.not_to be_open }
      end

      context 'when the pull request is rejected' do
        before { pull_request.update :state => 'rejected' }

        it { is_expected.to be_closed }
        it { is_expected.not_to be_open }
      end
    end
  end
end
