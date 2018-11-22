# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assets::Find do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:asset) { build :asset }

  ##
  # Subject
  #
  ##
  # Stubs and mocks
  #
  before do
    Stub::Command.create Repository::Asset::Find
  end

  ##
  # Tests
  #
  it 'finds the asset in the filesystem' do
    dbl = double 'Repository::Asset::Find'

    expect(Repository::Asset::Find).to receive(:new)
      .with(asset)
      .and_return dbl
    expect(dbl).to receive :execute

    subject.call asset
  end

  describe 'return value' do
    subject { described_class.call asset }

    it { is_expected.to be_nil }
  end
end
