# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Commit, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  before do
    Stub::Command.create Repository::Update, %i[content= author= message=]
  end

  ##
  # Test variables
  #
  let(:commit) { build :commit }

  ##
  # Subject
  #
  subject { commit }

  ##
  # Tests
  #
  describe 'attributes' do
    it { is_expected.not_to allow_value(nil).for(:content_items) }
    it { is_expected.not_to allow_value('').for(:content_items) }

    it { is_expected.not_to allow_value(nil).for(:message) }
    it { is_expected.not_to allow_value('').for(:message) }

    it 'is invalid without attributes' do
      expect(described_class.new).not_to be_valid
    end

    it 'is valid with valid attributes' do
      expect(build :commit).to be_valid
    end
  end

  describe 'associations' do
    it 'is not valid without topic' do
      expect(build :commit, :topic => nil).not_to be_valid
    end

    it 'is not valid without user' do
      expect(build :commit, :user => nil).not_to be_valid
    end
  end
end
