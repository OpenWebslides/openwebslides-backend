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
      subject(:alert) { build :update_alert, :alert_type => :topic_updated }

      it { is_expected.to be_valid }
      it { is_expected.to validate_presence_of :count }
      it { is_expected.to validate_numericality_of(:count).only_integer }

      context 'when count is non-nil' do
        before { alert.count = 1 }

        it { is_expected.to be_valid }
      end
    end

    %i[pr_submitted pr_accepted pr_rejected].each do |alert_type|
      context "when alert_type is `#{alert_type}`" do
        subject(:alert) { build :pull_request_alert, :alert_type => alert_type }

        it { is_expected.to be_valid }
        it { is_expected.not_to validate_presence_of :count }
        it { is_expected.not_to validate_numericality_of(:count).only_integer }

        context 'when count is non-nil' do
          before { alert.count = 1 }

          it { is_expected.not_to be_valid }
        end
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of :alerts }
    it { is_expected.to belong_to(:topic) }
    it { is_expected.to belong_to(:pull_request) }
    it { is_expected.to belong_to(:subject).class_name('User') }

    context 'when alert_type is `topic_updated`' do
      subject(:alert) { build :update_alert, :alert_type => :topic_updated }

      it { is_expected.to validate_presence_of :topic }
      it { is_expected.not_to validate_presence_of :pull_request }
      it { is_expected.not_to validate_presence_of :subject }

      context 'when topic is non-nil' do
        before { alert.topic = build(:topic) }

        it { is_expected.to be_valid }
      end

      context 'when pull_request is non-nil' do
        before { alert.pull_request = build(:pull_request) }

        it { is_expected.not_to be_valid }
      end

      context 'when subject is non-nil' do
        before { alert.subject = build(:user) }

        it { is_expected.not_to be_valid }
      end
    end

    %i[pr_submitted pr_accepted pr_rejected].each do |alert_type|
      context "when alert_type is `#{alert_type}`" do
        subject(:alert) { build :pull_request_alert, :alert_type => alert_type }

        it { is_expected.to validate_presence_of :topic }
        it { is_expected.to validate_presence_of :pull_request }
        it { is_expected.to validate_presence_of :subject }

        context 'when topic is non-nil' do
          before { alert.topic = build(:topic) }

          it { is_expected.to be_valid }
        end

        context 'when pull_request is non-nil' do
          before { alert.pull_request = build(:pull_request) }

          it { is_expected.to be_valid }
        end

        context 'when subject is non-nil' do
          before { alert.subject = build(:user) }

          it { is_expected.to be_valid }
        end
      end
    end
  end
end
