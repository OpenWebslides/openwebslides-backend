# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Annotation, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:annotation) { build :annotation }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'attributes' do
    it { is_expected.to validate_presence_of :content_item_id }
    it { is_expected.to validate_presence_of :state }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of :annotations }
    it { is_expected.to belong_to(:topic).inverse_of :annotations }

    it { is_expected.to have_many(:ratings).dependent(:destroy).inverse_of :annotation }
  end

  describe 'state machine' do
    it { is_expected.to have_states :created, :secret, :edited, :flagged, :hidden }

    context 'when state is :created' do
      it { is_expected.to handle_events :edit, :protect, :flag, :hide, :when => :created }
      it { is_expected.to reject_events :publish, :when => :created }

      it { is_expected.to transition_from :created, :to_state => :edited, :on_event => :edit }
      it { is_expected.to transition_from :created, :to_state => :secret, :on_event => :protect }
      it { is_expected.to transition_from :created, :to_state => :flagged, :on_event => :flag }
      it { is_expected.to transition_from :created, :to_state => :hidden, :on_event => :hide }
    end

    context 'when state is :edited' do
      it { is_expected.to handle_events :edit, :flag, :hide, :when => :edited }
      it { is_expected.to reject_events :protect, :publish, :when => :edited }

      it { is_expected.to transition_from :edited, :to_state => :edited, :on_event => :edit }
      it { is_expected.to transition_from :edited, :to_state => :flagged, :on_event => :flag }
      it { is_expected.to transition_from :edited, :to_state => :hidden, :on_event => :hide }
    end

    context 'when state is :secret' do
      it { is_expected.to handle_events :edit, :publish, :hide, :when => :secret }
      it { is_expected.to reject_events :protect, :flag, :when => :secret }

      it { is_expected.to transition_from :secret, :to_state => :secret, :on_event => :edit }
      it { is_expected.to transition_from :secret, :to_state => :created, :on_event => :publish }
    end

    context 'when state is :flagged' do
      it { is_expected.to handle_events :hide, :when => :flagged }
      it { is_expected.to reject_events :edit, :protect, :publish, :flag, :when => :flagged }

      it { is_expected.to transition_from :flagged, :to_state => :hidden, :on_event => :hide }
    end

    context 'when state is :hidden' do
      it { is_expected.to reject_events :hide, :edit, :protect, :publish, :flag, :when => :hidden }
    end
  end

  describe 'methods' do
    describe '#locked?' do
      context 'when annotation is unlocked' do
        it { is_expected.not_to be_locked }
      end

      context 'when annotation is flagged' do
        before { annotation.flag }

        it { is_expected.to be_locked }
      end

      context 'when annotation is hidden' do
        before { annotation.hide }

        it { is_expected.to be_locked }
      end
    end
  end
end
