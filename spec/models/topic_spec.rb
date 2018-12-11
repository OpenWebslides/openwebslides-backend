# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topic, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:topic) { create :topic }

  ##
  # Test variables
  #
  let(:fork) { create :topic, :upstream => topic }
  let(:user) { create :user }

  let(:upstream) { create :topic, :forks => create_list(:topic, 3) }
  let(:downstream) { create :topic, :upstream => upstream }

  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'attributes' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :access }
    it { is_expected.to validate_presence_of :root_content_item_id }

    describe 'cannot have a more permissive access level than the upstream' do
      context 'when the upstream is public' do
        let(:upstream) { create :topic, :access => :public }

        context 'when the fork is public' do
          subject(:topic) { build :topic, :upstream => upstream, :access => :public }

          it { is_expected.to be_valid }
        end

        context 'when the fork is protected' do
          subject(:topic) { build :topic, :upstream => upstream, :access => :protected }

          it { is_expected.to be_valid }
        end

        context 'when the fork is private' do
          subject(:topic) { build :topic, :upstream => upstream, :access => :private }

          it { is_expected.to be_valid }
        end
      end

      context 'when the upstream is protected' do
        let(:upstream) { create :topic, :access => :protected }

        context 'when the fork is public' do
          subject(:topic) { build :topic, :upstream => upstream, :access => :public }

          it { is_expected.not_to be_valid }
        end

        context 'when the fork is protected' do
          subject(:topic) { build :topic, :upstream => upstream, :access => :protected }

          it { is_expected.to be_valid }
        end

        context 'when the fork is private' do
          subject(:topic) { build :topic, :upstream => upstream, :access => :private }

          it { is_expected.to be_valid }
        end
      end

      context 'when the upstream is private' do
        let(:upstream) { create :topic, :access => :private }

        context 'when the fork is public' do
          subject(:topic) { build :topic, :upstream => upstream, :access => :public }

          it { is_expected.not_to be_valid }
        end

        context 'when the fork is protected' do
          subject(:topic) { build :topic, :upstream => upstream, :access => :protected }

          it { is_expected.not_to be_valid }
        end

        context 'when the fork is private' do
          subject(:topic) { build :topic, :upstream => upstream, :access => :private }

          it { is_expected.to be_valid }
        end
      end
    end
  end

  describe 'state machine' do
    let(:subject) { build :topic }

    it { is_expected.to have_states :public, :private, :protected }

    context 'when the topic is public' do
      it { is_expected.to handle_events :set_private, :set_protected, :when => :public }

      it { is_expected.to transition_from :public, :to_state => :private, :on_event => :set_private }
      it { is_expected.to transition_from :public, :to_state => :protected, :on_event => :set_protected }
    end

    context 'when the topic is protected' do
      it { is_expected.to handle_events :set_private, :set_public, :when => :protected }

      it { is_expected.to transition_from :protected, :to_state => :private, :on_event => :set_private }
      it { is_expected.to transition_from :protected, :to_state => :public, :on_event => :set_public }
    end

    context 'when the topic is private' do
      it { is_expected.to handle_events :set_protected, :set_public, :when => :private }

      it { is_expected.to transition_from :private, :to_state => :protected, :on_event => :set_protected }
      it { is_expected.to transition_from :private, :to_state => :public, :on_event => :set_public }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of :topics }
    # TODO: Only shoulda-matchers > 3.1.2 support the `optional` condition
    it { is_expected.to belong_to(:upstream).inverse_of(:forks).class_name('Topic') }

    it { is_expected.to have_many(:forks).inverse_of(:upstream).class_name('Topic').with_foreign_key :upstream_id }
    it { is_expected.to have_many(:grants).dependent :destroy }
    it { is_expected.to have_many(:collaborators).through(:grants).source(:user).class_name('User').inverse_of :collaborations }
    it { is_expected.to have_many(:assets).inverse_of(:topic).dependent :destroy }
    it { is_expected.to have_many(:feed_items).inverse_of(:topic).dependent :destroy }
    it { is_expected.to have_many(:annotations).inverse_of(:topic).dependent :destroy }
    it { is_expected.to have_many(:conversations).inverse_of :topic }
    it { is_expected.to have_many(:incoming_pull_requests).inverse_of(:target).class_name('PullRequest').dependent :destroy }
    it { is_expected.to have_many(:outgoing_pull_requests).inverse_of(:source).class_name('PullRequest').dependent :destroy }

    context 'when the upstream is not a fork' do
      subject { build :topic, :upstream => topic }

      it { is_expected.to be_valid }
      it { is_expected.to have_attributes :upstream => topic }
    end

    context 'when the upstream is a fork' do
      subject { build :topic, :upstream => fork }

      it { is_expected.not_to be_valid }
    end

    context 'with an upstream' do
      context 'with forks' do
        subject { build :topic, :upstream => create(:topic), :forks => [create(:topic)] }

        it { is_expected.not_to be_valid }
      end

      context 'without forks' do
        subject { build :topic, :upstream => create(:topic), :forks => [] }

        it { is_expected.to be_valid }
      end
    end

    context 'without an upstream' do
      context 'with forks' do
        subject { build :topic, :upstream => nil, :forks => [create(:topic)] }

        it { is_expected.to be_valid }
      end

      context 'without forks' do
        subject { build :topic, :upstream => nil, :forks => [] }

        it { is_expected.to be_valid }
      end
    end
  end

  describe 'methods' do
    describe '#content_id' do
      it { is_expected.to respond_to :content_id }
      it { is_expected.to have_attributes :content_id => topic.id }
    end

    describe '#content' do
      it { is_expected.to respond_to :content }
      it { is_expected.to have_attributes :content => nil }
    end

    describe '#pull_request' do
      let(:open_pr) { create :pull_request, :source => fork, :target => topic }

      before do
        create :pull_request, :source => fork, :target => topic, :state => 'rejected', :feedback => 'feedback'
        create :pull_request, :source => fork, :target => topic, :state => 'accepted'
      end

      context 'when there is an open pull request' do
        it 'returns the only open outgoing pull request' do
          # Reload objects to refetch associations
          open_pr.reload
          fork.reload

          expect(fork.pull_request).to eq open_pr
        end
      end

      context 'when this is no open pull request' do
        it 'returns nil' do
          # Don't reload objects
          expect(fork.pull_request).to be_nil
        end
      end
    end
  end
end
