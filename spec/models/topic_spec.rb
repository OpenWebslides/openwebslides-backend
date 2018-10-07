# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topic, :type => :model do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  subject { topic }

  let(:topic) { create :topic, :with_assets }
  let(:user) { create :user }

  let(:upstream) { create :topic, :forks => create_list(:topic, 3) }
  let(:downstream) { create :topic, :upstream => upstream }

  ##
  # Test subject
  #

  ##
  # Stubs
  #
  before do
    Stub::Command.create Repository::Create
    Stub::Command.create Repository::Update, %i[content= author= message=]
    Stub::Command.create Repository::Fork, %i[author= fork=]
  end

  ##
  # Tests
  #
  describe 'attributes' do
    it { is_expected.not_to allow_value(nil).for(:title) }
    it { is_expected.not_to allow_value('').for(:title) }

    it { is_expected.not_to allow_value(nil).for(:state) }
    it { is_expected.not_to allow_value('').for(:state) }

    it { is_expected.not_to allow_value(nil).for(:root_content_item_id) }
    it { is_expected.not_to allow_value('').for(:root_content_item_id) }

    it 'is invalid without attributes' do
      expect(described_class.new).not_to be_valid
    end

    it { is_expected.to be_valid }

    it 'has a valid :status enum' do
      expect(%w[public_access protected_access private_access]).to include subject.state
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:topics) }
    it { is_expected.to belong_to(:upstream).inverse_of(:forks) }

    it { is_expected.to have_many(:forks).inverse_of(:upstream) }
    it { is_expected.to have_many(:grants).dependent(:destroy) }
    it { is_expected.to have_many(:collaborators).through(:grants).inverse_of(:collaborations) }
    it { is_expected.to have_many(:assets).dependent(:destroy).inverse_of(:topic) }
    it { is_expected.to have_many(:feed_items).dependent(:destroy).inverse_of(:topic) }
    it { is_expected.to have_many(:annotations).dependent(:destroy).inverse_of(:topic) }
    it { is_expected.to have_many(:conversations).inverse_of(:topic) }
    it { is_expected.to have_many(:incoming_pull_requests).class_name('PullRequest').dependent(:destroy).inverse_of(:target) }
    it { is_expected.to have_many(:outgoing_pull_requests).class_name('PullRequest').dependent(:destroy).inverse_of(:source) }

    context 'not a fork' do
      describe 'upstream' do
        it 'is empty' do
          expect(upstream.upstream).to be_nil
          expect(upstream).to be_valid
        end

        it 'must be empty' do
          upstream.upstream = topic
          expect(upstream).not_to be_valid
        end
      end

      describe 'forks' do
        it 'is non-empty' do
          expect(upstream.forks).not_to be_empty
          expect(upstream).to be_valid
        end

        it 'can be empty' do
          upstream.forks.clear
          expect(upstream).to be_valid
        end
      end
    end

    context 'a fork' do
      describe 'upstream' do
        it 'is not empty' do
          expect(downstream.upstream).not_to be_nil
          expect(downstream).to be_valid
        end

        it 'can be empty' do
          downstream.upstream = nil
          expect(downstream).to be_valid
        end
      end

      describe 'forks' do
        it 'is empty' do
          expect(downstream.forks).to be_empty
          expect(downstream).to be_valid
        end

        it 'must be empty' do
          downstream.forks << topic
          expect(downstream).not_to be_valid
        end
      end

      it 'cannot be a fork of another fork' do
        expect(build :topic, :upstream => downstream).not_to be_valid
      end
    end

    describe 'upstream and forks' do
      it 'is valid when no upstream and no forks' do
        subject.upstream = nil
        subject.forks.clear

        expect(subject.upstream).to be_nil
        expect(subject.forks).to be_empty

        expect(subject).to be_valid
      end

      it 'is valid when upstream and no forks' do
        subject.upstream = build :topic
        subject.forks.clear

        expect(subject.upstream).not_to be_nil
        expect(subject.forks).to be_empty

        expect(subject).to be_valid
      end

      it 'is valid when no upstream and forks' do
        subject.upstream = nil
        subject.forks = build_list :topic, 3

        expect(subject.upstream).to be_nil
        expect(subject.forks).not_to be_empty

        expect(subject).to be_valid
      end

      it 'is invalid when upstream and forks' do
        subject.upstream = build :topic
        subject.forks << build(:topic)

        expect(subject.upstream).not_to be_nil
        expect(subject.forks).not_to be_empty

        expect(subject).not_to be_valid
      end
    end
  end

  describe 'methods' do
    it 'overrides inclusion methods for content' do
      expect(topic).to respond_to :content
      expect(topic).to respond_to :content_id
    end

    describe '#pull_request' do
      let(:open_pr) { create :pull_request, :source => downstream, :target => upstream }

      before do
        create(:pull_request, :source => downstream, :target => upstream).reject
        create(:pull_request, :source => downstream, :target => upstream).accept
      end

      context 'when there is an open pull request' do
        it 'returns the only open outgoing pull request' do
          # Reload objects to refetch associations
          open_pr.reload
          downstream.reload

          expect(downstream.pull_request).to eq open_pr
        end
      end

      context 'when this is no open pull request' do
        it 'returns nil' do
          # Don't reload objects
          expect(downstream.pull_request).to be_nil
        end
      end
    end
  end
end
