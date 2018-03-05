# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, :type => :model do
  let(:subject) { create :comment }

  describe 'attributes' do
    it { is_expected.not_to allow_value(nil).for(:text) }
    it { is_expected.not_to allow_value('').for(:text) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:conversation).inverse_of(:comments) }
  end

  describe 'scope' do
    let(:conversation) { create :conversation }

    it 'topic must be equal to its parent conversation' do
      comment = build :comment,
                      :conversation => conversation,
                      :topic => create(:topic),
                      :content_item_id => conversation.content_item_id

      expect(comment).not_to be_valid
    end

    it 'content_item_id must be equal to its parent conversation' do
      comment = build :comment,
                      :conversation => conversation,
                      :topic => conversation.topic,
                      :content_item_id => Faker::Number.number(2)

      expect(comment.content_item_id).not_to eq comment.conversation.content_item_id

      expect(comment).not_to be_valid
    end

    it 'is equal to its parent conversation' do
      comment = build :comment,
                      :conversation => conversation,
                      :topic => conversation.topic,
                      :content_item_id => conversation.content_item_id

      expect(comment).to be_valid
    end

    context 'hidden parent conversation' do
      before { conversation.hide }

      it 'is not valid' do
        comment = build :comment,
                        :conversation => conversation,
                        :topic => conversation.topic,
                        :content_item_id => conversation.content_item_id

        expect(comment).not_to be_valid
      end
    end

    context 'flagged parent conversation' do
      before { conversation.flag }

      it 'is not valid' do
        comment = build :comment,
                        :conversation => conversation,
                        :topic => conversation.topic,
                        :content_item_id => conversation.content_item_id

        expect(comment).not_to be_valid
      end
    end
  end

  describe 'methods' do
    describe 'locked?' do
      let(:subject) { create :comment }

      context 'unlocked' do
        it { is_expected.not_to be_locked }
      end

      context 'flagged' do
        before { subject.conversation.flag }
        it { is_expected.to be_locked }
      end

      context 'hidden' do
        before { subject.conversation.hide }
        it { is_expected.to be_locked }
      end
    end
  end
end
