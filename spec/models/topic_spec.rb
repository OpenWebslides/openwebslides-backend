# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topic, :type => :model do
  let(:topic) { build :topic, :with_assets }
  let(:user) { build :user }

  describe 'attributes' do
    it { is_expected.not_to allow_value(nil).for(:name) }
    it { is_expected.not_to allow_value('').for(:name) }

    it { is_expected.not_to allow_value(nil).for(:state) }
    it { is_expected.not_to allow_value('').for(:state) }

    it { is_expected.not_to allow_value(nil).for(:template) }
    it { is_expected.not_to allow_value('').for(:template) }

    it 'is invalid without attributes' do
      expect(subject).not_to be_valid
    end

    it 'is valid with attributes' do
      expect(topic).to be_valid
    end

    it 'has a valid :status enum' do
      expect(%w[public_access protected_access private_access]).to include topic.state
    end

    it 'has a canonical name' do
      topic.send :generate_canonical_name
      expect(topic.canonical_name).not_to be_nil
    end

    it 'has a default template' do
      expect(topic.template).not_to be_nil
      expect(topic.template).not_to be_empty
    end

    it 'has an overridable template' do
      new_template = Faker::Lorem.words(2).join ' '

      topic = build :topic, :template => new_template

      expect(topic.template).to eq new_template
    end

    let(:user) { build :user, :email => 'foo@bar' }
    it 'has a unique canonical name' do
      topic = create :topic, :name => 'Foo Bar', :user => user
      expect(topic.canonical_name).to eq 'foo-bar-foo-bar'

      topic2 = create :topic, :name => 'Foo Bar', :user => user
      expect(topic2.canonical_name).to eq 'foo-bar-foo-bar-2'
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
