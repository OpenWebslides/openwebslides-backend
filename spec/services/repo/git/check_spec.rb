# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Check do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # Subject
  #
  subject { described_class.call source.topic, target.topic }

  ##
  # Test variables
  #
  let(:source) { Repository.new :topic => create(:topic) }
  let(:target) { Repository.new :topic => create(:topic) }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  context 'when the source has commits A and B' do
    before { allow(Repo::Git::Log).to receive(:call).with(source).and_return %w[A B] }

    context 'when the target only has commit A' do
      before { allow(Repo::Git::Log).to receive(:call).with(target).and_return %w[A] }

      it { is_expected.to be false }
    end

    context 'when the target only has commit D' do
      before { allow(Repo::Git::Log).to receive(:call).with(target).and_return %w[D] }

      it { is_expected.to be false }
    end

    context 'when the target has commits A and B' do
      before { allow(Repo::Git::Log).to receive(:call).with(target).and_return %w[A B] }

      it { is_expected.to be false }
    end

    context 'when the target has commits A, B and C' do
      before { allow(Repo::Git::Log).to receive(:call).with(target).and_return %w[A B C] }

      it { is_expected.to be true }
    end

    context 'when the target has commits A, C and B' do
      before { allow(Repo::Git::Log).to receive(:call).with(target).and_return %w[A C B] }

      it { is_expected.to be true }
    end

    context 'when the target has commits C, A and B' do
      before { allow(Repo::Git::Log).to receive(:call).with(target).and_return %w[C A B] }

      it { is_expected.to be true }
    end

    context 'when the target has commits A and D' do
      before { allow(Repo::Git::Log).to receive(:call).with(target).and_return %w[A D] }

      it { is_expected.to be false }
    end
  end
end
