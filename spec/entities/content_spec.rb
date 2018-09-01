# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Content, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  before do
    Stub::Command.create Repository::Read
  end

  ##
  # Test variables
  #
  subject { content }

  let(:content) { build :content }

  ##
  # Subject
  #

  ##
  # Tests
  #
  describe 'attributes' do
    it { is_expected.not_to allow_value(nil).for(:content_items) }
    it { is_expected.not_to allow_value('').for(:content_items) }

    it 'is invalid without attributes' do
      expect(described_class.new).not_to be_valid
    end

    it 'is valid with valid attributes' do
      expect(build :content).to be_valid
    end
  end

  describe 'associations' do
    it 'is not valid without topic' do
      expect(build :content, :topic => nil).not_to be_valid
    end
  end

  describe 'methods' do
    describe '.find' do
      it 'returns a content' do
        expect(described_class.find subject.topic.id).to be_a Content
      end
    end
  end
end
