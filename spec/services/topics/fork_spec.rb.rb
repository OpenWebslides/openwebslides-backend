# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::Fork do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:topic) { create :topic }
  let(:user) { create :user }

  ##
  # Subject
  #
  ##
  # Stubs and mocks
  #
  before do
    Stub::Command.create Repository::Fork, %i[fork=]
  end

  ##
  # Tests
  #
  describe 'the forked topic' do
    subject { described_class.call topic, user }

    it { is_expected.to be_persisted }
    it 'attributes' do
      is_expected.to have_attributes :title => I18n.t('openwebslides.topics.forked', :title => topic.title),
                                     :description => topic.description,
                                     :state => topic.state,
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
    expect(Notifications::Fork).to receive(:call).with instance_of Topic

    subject.call topic, user
  end
end
