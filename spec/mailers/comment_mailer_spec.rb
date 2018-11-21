# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentMailer do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  ##
  # Subject
  #
  let(:user) { create :user, :confirmed }

  ##
  # Tests
  #
  describe '#create' do
    let(:mail) { described_class.create comment }
    let(:comment) { create :comment }

    it 'sets the headers' do
      expect(mail.subject).to match comment.topic.title
      expect(mail.to).to match_array [comment.conversation.user.email, comment.topic.user.email]
    end

    it 'sets the body' do
      expect(mail.body.encoded).to match comment.text
    end
  end
end
