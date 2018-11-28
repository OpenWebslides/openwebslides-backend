# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequestPolicy::Scope do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:scope) { described_class.new(user, PullRequest).resolve.count }

  ##
  # Test variables
  #
  let(:pr_user) { create :user, :confirmed }

  let(:source) { create :topic, :upstream => target }
  let(:target) { create :topic }

  before do
    create(:pull_request, :user => pr_user, :source => source, :target => target).reject
    create(:pull_request, :user => pr_user, :source => source, :target => target).accept
    create(:pull_request, :user => pr_user, :source => source, :target => target)
  end

  ##
  # Tests
  #
  context 'when the user is a guest' do
    let(:user) { nil }

    it { is_expected.to eq 0 }
  end

  context 'when the user is a user' do
    let(:user) { create :user }

    it { is_expected.to eq 0 }

    context 'when the source is updatable' do
      before { source.collaborators << user }

      it { is_expected.to eq 3 }
    end

    context 'when the target is updatable' do
      before { target.collaborators << user }

      it { is_expected.to eq 3 }
    end
  end

  context 'when the user is the same' do
    let(:user) { pr_user }

    it { is_expected.to eq 0 }

    context 'when the source is updatable' do
      before { source.collaborators << user }

      it { is_expected.to eq 3 }
    end

    context 'when the target is updatable' do
      before { target.collaborators << user }

      it { is_expected.to eq 3 }
    end
  end
end
