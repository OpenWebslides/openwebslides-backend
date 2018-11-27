# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::Fork do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # Test variables
  #
  ##
  # Subject
  #
  let(:topic) { create :topic }
  let(:user) { create :user }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before { Topics::Create.call topic }

  describe 'the forked topic' do
    subject { described_class.call topic, user }

    it { is_expected.to be_persisted }
    it 'attributes' do
      is_expected.to have_attributes :title => I18n.t('openwebslides.topics.forked', :title => topic.title),
                                     :description => topic.description,
                                     :access => topic.access,
                                     :root_content_item_id => topic.root_content_item_id,
                                     :upstream => topic,
                                     :user => user
    end

    it 'has duplicated assets' do
      # Filename is the only attribute of Asset
      expect(subject.assets.pluck :filename).to match_array topic.assets.pluck(:filename)
    end
  end

  it 'calls Notifications::Fork' do
    expect(Notifications::ForkTopic).to receive(:call).with instance_of Topic

    subject.call topic, user
  end

  describe 'return value' do
    subject { described_class.call topic, user }

    it { is_expected.to be_instance_of Topic }
    it { is_expected.to be_valid }
  end
end
