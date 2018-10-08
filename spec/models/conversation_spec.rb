# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Conversation, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:conversation) { build :conversation }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'attributes' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :text }
    it { is_expected.to validate_presence_of :conversation_type }

    it { is_expected.to define_enum_for(:conversation_type).with %i[question note] }
  end

  describe 'associations' do
    it { is_expected.to have_many(:comments).inverse_of(:conversation).dependent :destroy }
  end
end
