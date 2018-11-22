# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConversationMailer do
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
    let(:mail) { described_class.create conversation }
    let(:conversation) { create :conversation }

    it 'sets the headers' do
      expect(mail.subject).to match conversation.topic.title
      expect(mail.to).to eq [conversation.topic.user.email]
    end

    it 'sets the body' do
      expect(mail.body.encoded).to match conversation.title
    end
  end
end
