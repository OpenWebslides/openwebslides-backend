# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topic, :type => :model do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:topic) { build :topic, :with_assets }
  let(:user) { build :user }

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

    it 'generates a feed_item on create' do
      count = FeedItem.count

      d = build :topic
      TopicService.new(d).create

      expect(FeedItem.count).to eq count + 1
      expect(FeedItem.last.event_type).to eq 'topic_created'
      expect(FeedItem.last.topic).to eq d
    end

    it 'generates a feed_item on update' do
      d = create :topic

      count = FeedItem.count

      TopicService.new(d).update :author => user, :content => 'foo'

      expect(FeedItem.count).to eq count + 1
      expect(FeedItem.last.event_type).to eq 'topic_updated'
      expect(FeedItem.last.topic).to eq d
    end

    describe 'upstream and forks' do
      let(:upstream) { create :topic }
      let(:topic) { create :topic, :upstream => upstream }
      let(:topic2) { create :topic, :upstream => upstream }

      it 'has an upstream' do
        expect(topic.upstream).to eq upstream
        expect(topic2.upstream).to eq upstream

        expect(upstream.upstream).to be_nil
      end

      it 'has forks' do
        expect(topic.forks).to be_empty
        expect(topic2.forks).to be_empty

        expect(upstream.forks).to include topic, topic2
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
