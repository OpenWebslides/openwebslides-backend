# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequestPolicy do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:policy) { described_class.new user, pull_request }

  ##
  # Test variables
  #
  let(:pull_request) { create :pull_request }

  ##
  # Tests
  #
  context 'when the user is a guest' do
    let(:user) { nil }

    it { is_expected.to forbid_action :show }
    it { is_expected.to forbid_action :create }

    it { is_expected.to forbid_action :show_user }
    it { is_expected.to forbid_action :show_source }
    it { is_expected.to forbid_action :show_target }
  end

  context 'when the user is just a user' do
    let(:user) { build :user }

    it { is_expected.to forbid_action :show }
    it { is_expected.to forbid_action :create }

    it { is_expected.to forbid_action :show_user }
    it { is_expected.to forbid_action :show_source }
    it { is_expected.to forbid_action :show_target }

    context 'when the source is updatable' do
      before { pull_request.source.collaborators << user }

      it { is_expected.to permit_action :show }
      it { is_expected.to forbid_action :create }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_source }
      it { is_expected.to permit_action :show_target }
    end

    context 'when the target is updatable' do
      before { pull_request.target.collaborators << user }

      it { is_expected.to permit_action :show }
      it { is_expected.to forbid_action :create }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_source }
      it { is_expected.to permit_action :show_target }
    end
  end

  context 'when the user is an owner' do
    let(:user) { pull_request.user }

    it { is_expected.to forbid_action :show }
    it { is_expected.to forbid_action :create }

    it { is_expected.to forbid_action :show_user }
    it { is_expected.to forbid_action :show_source }
    it { is_expected.to forbid_action :show_target }

    context 'when the source is updatable' do
      before { pull_request.source.collaborators << user }

      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_source }
      it { is_expected.to permit_action :show_target }

      context 'when the target is showable' do
        it { is_expected.to permit_action :create }
      end

      context 'when the target is not showable' do
        before { pull_request.target.update :state => :private_access }

        it { is_expected.to forbid_action :create }
      end
    end

    context 'when the target is updatable' do
      before { pull_request.target.collaborators << user }

      it { is_expected.to permit_action :show }
      it { is_expected.to forbid_action :create }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_source }
      it { is_expected.to permit_action :show_target }
    end
  end
end
