# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alert, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  subject(:alert) { build :alert }

  ##
  # Tests
  #
  describe 'attributes' do
    it { is_expected.to allow_values(false, 'false', true, 'true').for :read }
    it { is_expected.to define_enum_for(:alert_type).with %i[topic_updated pr_submitted pr_accepted pr_rejected] }

    context 'when alert_type is `topic_updated`' do
      subject(:alert) { build :alert, :alert_type => :topic_updated }

      it { is_expected.to validate_presence_of :count }
      it { is_expected.to validate_numericality_of(:count).only_integer }
    end

    context 'when alert_type is `pr_submitted`' do
      subject(:alert) { build :alert, :alert_type => :pr_submitted }

      it { is_expected.not_to validate_presence_of :count }
      it { is_expected.not_to validate_numericality_of(:count).only_integer }
    end

    context 'when alert_type is `pr_accepted`' do
      subject(:alert) { build :alert, :alert_type => :pr_accepted }

      it { is_expected.not_to validate_presence_of :count }
      it { is_expected.not_to validate_numericality_of(:count).only_integer }
    end

    context 'when alert_type is `pr_rejected`' do
      subject(:alert) { build :alert, :alert_type => :pr_rejected }

      it { is_expected.not_to validate_presence_of :count }
      it { is_expected.not_to validate_numericality_of(:count).only_integer }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of :alerts }
    it { is_expected.to belong_to(:topic) }
    it { is_expected.to belong_to(:pull_request) }
    it { is_expected.to belong_to(:subject).class_name('User') }

    context 'when alert_type is `topic_updated`' do
      subject(:alert) { build :alert, :alert_type => :topic_updated }

      it { is_expected.to validate_presence_of :topic }
      it { is_expected.not_to validate_presence_of :pull_request }
      it { is_expected.not_to validate_presence_of :subject }
    end

    context 'when alert_type is `pr_submitted`' do
      subject(:alert) { build :alert, :alert_type => :pr_submitted }

      it { is_expected.not_to validate_presence_of :topic }
      it { is_expected.to validate_presence_of :pull_request }
      it { is_expected.to validate_presence_of :subject }
    end

    context 'when alert_type is `pr_accepted`' do
      subject(:alert) { build :alert, :alert_type => :pr_accepted }

      it { is_expected.not_to validate_presence_of :topic }
      it { is_expected.to validate_presence_of :pull_request }
      it { is_expected.to validate_presence_of :subject }
    end

    context 'when alert_type is `pr_rejected`' do
      subject(:alert) { build :alert, :alert_type => :pr_rejected }

      it { is_expected.not_to validate_presence_of :topic }
      it { is_expected.to validate_presence_of :pull_request }
      it { is_expected.to validate_presence_of :subject }
    end
  end
end
