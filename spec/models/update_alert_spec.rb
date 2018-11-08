# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateAlert, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  subject(:alert) { create :update_alert }

  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'attributes' do
    it { is_expected.to validate_presence_of :count }
    it { is_expected.to validate_numericality_of(:count).only_integer }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of :alerts }
  end

  describe 'methods' do
    describe '#alert_type' do
      it 'is a topic updated alert' do
        expect(subject.alert_type).to eq :topic_updated
      end
    end
  end
end
