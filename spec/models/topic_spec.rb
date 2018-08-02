# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topic, :type => :model do
  let(:topic) { build :topic, :with_assets }
  let(:user) { build :user }

  before :each do
    Stub::Command.create Repository::Create
    Stub::Command.create Repository::Update, %i[content= author= message=]
  end

  describe 'attributes' do
    it { is_expected.not_to allow_value(nil).for(:title) }
    it { is_expected.not_to allow_value('').for(:title) }

    it { is_expected.not_to allow_value(nil).for(:state) }
    it { is_expected.not_to allow_value('').for(:state) }

    it 'is invalid without attributes' do
      expect(subject).not_to be_valid
    end

    it 'is valid with attributes' do
      expect(topic).to be_valid
    end

    it 'has a valid :status enum' do
      expect(%w[public_access protected_access private_access]).to include topic.state
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:topics) }
    it { is_expected.to have_many(:grants).dependent(:destroy) }
    it { is_expected.to have_many(:collaborators).through(:grants).inverse_of(:collaborations) }
    it { is_expected.to have_many(:assets).dependent(:destroy).inverse_of(:topic) }
    it { is_expected.to have_many(:notifications).dependent(:destroy).inverse_of(:topic) }
    it { is_expected.to have_many(:annotations).dependent(:destroy).inverse_of(:topic) }
    it { is_expected.to have_many(:conversations).inverse_of(:topic) }

    it 'generates a notification on create' do
      count = Notification.count

      d = build :topic
      TopicService.new(d).create

      expect(Notification.count).to eq count + 1
      expect(Notification.last.event_type).to eq 'topic_created'
      expect(Notification.last.topic).to eq d
    end

    it 'generates a notification on update' do
      d = create :topic

      count = Notification.count

      TopicService.new(d).update :author => user, :content => 'foo'

      expect(Notification.count).to eq count + 1
      expect(Notification.last.event_type).to eq 'topic_updated'
      expect(Notification.last.topic).to eq d
    end
  end
end
