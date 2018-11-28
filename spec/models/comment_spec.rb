# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:comment) { build :comment }

  ##
  # Test variables
  #
  let(:topic) { build :topic }

  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'attributes' do
    it { is_expected.to validate_presence_of :text }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:conversation).inverse_of :comments }

    context 'when the parent conversation topic is not the same' do
      before { comment.conversation.topic = topic }

      it { is_expected.not_to be_valid }
    end

    context 'when the parent conversation content_item_id is not the same' do
      before { comment.conversation.content_item_id = 'foobar' }

      it { is_expected.not_to be_valid }
    end

    context 'when the parent conversation is hidden' do
      before { comment.conversation.hide }

      it { is_expected.not_to be_valid }
    end

    context 'when the parent conversation is flagged' do
      before { comment.conversation.flag }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'methods' do
    describe '#locked?' do
      context 'when the parent conversation is unlocked' do
        it { is_expected.not_to be_locked }
      end

      context 'when the parent conversation is flagged' do
        before { comment.conversation.flag }

        it { is_expected.to be_locked }
      end

      context 'when the parent conversation is hidden' do
        before { comment.conversation.hide }

        it { is_expected.to be_locked }
      end
    end
  end
end
