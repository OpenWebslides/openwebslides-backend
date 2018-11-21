# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebUrlHelper do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  let(:topic) { create :topic }
  let(:conversation) { create :conversation }
  let(:comment) { create :comment }

  ##
  # Tests
  #
  describe '#web_topic_editor_url' do
    subject(:url) { helper.web_topic_editor_url(topic) }

    it { is_expected.to eq "#{root_url}topic/#{topic.id}/editor" }
  end

  describe '#web_topic_viewer_url' do
    subject(:url) { helper.web_topic_viewer_url(topic) }

    it { is_expected.to eq "#{root_url}topic/#{topic.id}/viewer" }
  end

  describe '#web_conversation_url' do
    subject(:url) { helper.web_conversation_url(conversation) }

    it { is_expected.to eq "#{root_url}topic/#{conversation.topic.id}/viewer" }
  end

  describe '#web_comment_url' do
    subject(:url) { helper.web_comment_url(comment) }

    it { is_expected.to eq "#{root_url}topic/#{comment.topic.id}/viewer" }
  end
end
