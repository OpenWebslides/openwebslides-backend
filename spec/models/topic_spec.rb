# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topic, :type => :model do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:topic) { create :topic, :with_assets }
  let(:user) { create :user }

  let(:upstream) { create :topic, :forks => create_list(:topic, 3) }
  let(:downstream) { create :topic, :upstream => upstream }

  ##
  # Test subject
  #
  subject { topic }

  ##
  # Stubs
  #
  before :each do
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

    ## TODO: move this to topic acceptance spec
    it 'generates a feed_item on create' do
      count = FeedItem.count

      d = build :topic
      TopicService.new(d).create

      expect(FeedItem.count).to eq count + 1
      expect(FeedItem.last.event_type).to eq 'topic_created'
      expect(FeedItem.last.topic).to eq d
    end

    # TODO: move this to topic acceptance spec
    it 'generates a feed_item on update' do
      d = create :topic

      count = FeedItem.count

      TopicService.new(d).update :author => user, :content => 'foo'

      expect(FeedItem.count).to eq count + 1
      expect(FeedItem.last.event_type).to eq 'topic_updated'
      expect(FeedItem.last.topic).to eq d
    end

    # TODO: move this to topic acceptance spec
    it 'generates a feed_item on fork' do
      d = create :topic

      count = FeedItem.count

      TopicService.new(d).fork :author => user, :fork => d.dup

      expect(FeedItem.count).to eq count + 1
      expect(FeedItem.last.event_type).to eq 'topic_forked'
      expect(FeedItem.last.topic).to eq d
    end

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
  end
end
