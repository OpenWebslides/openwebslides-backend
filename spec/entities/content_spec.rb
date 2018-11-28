# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Content, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  let(:content) { build :content }

  ##
  # Subject
  #
  subject { content }

  ##
  # Tests
  #
  describe 'attributes' do
    it { is_expected.not_to allow_value(nil).for(:content) }
    it { is_expected.not_to allow_value('').for(:content) }

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
end
