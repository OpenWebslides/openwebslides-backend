# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequestPolicy do
  subject { described_class.new user, record }

  let(:record) { create :pull_request }

  context 'when the user is a guest' do
    let(:user) { nil }

    it { is_expected.to forbid_action :show }

    it { is_expected.to forbid_action :show_user }
    it { is_expected.to forbid_action :show_source }
    it { is_expected.to forbid_action :show_target }
  end

  context 'when the user is a user' do
    let(:user) { build :user }

    it { is_expected.to forbid_action :show }

    it { is_expected.to forbid_action :show_user }
    it { is_expected.to forbid_action :show_source }
    it { is_expected.to forbid_action :show_target }

    context 'when the source is updatable' do
      before { record.source.collaborators << user }

      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_source }
      it { is_expected.to permit_action :show_target }
    end

    context 'when the target is updatable' do
      before { record.source.collaborators << user }

      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_source }
      it { is_expected.to permit_action :show_target }
    end
  end

  context 'when the user is the same' do
    let(:user) { record.user }

    it { is_expected.to forbid_action :show }

    it { is_expected.to forbid_action :show_user }
    it { is_expected.to forbid_action :show_source }
    it { is_expected.to forbid_action :show_target }

    context 'when the source is updatable' do
      before { record.source.collaborators << user }

      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_source }
      it { is_expected.to permit_action :show_target }
    end

    context 'when the target is updatable' do
      before { record.source.collaborators << user }

      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_source }
      it { is_expected.to permit_action :show_target }
    end
  end
end
