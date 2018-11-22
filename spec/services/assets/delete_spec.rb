# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assets::Delete do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:asset) { build :asset, :topic => create(:topic) }
  let(:user) { build :user }

  ##
  # Subject
  #
  ##
  # Stubs and mocks
  #
  before do
    Stub::Command.create Repository::Asset::Destroy, %i[author=]
  end

  ##
  # Tests
  #
  it 'destroys the topic in the database' do
    subject.call asset, user

    expect(asset).to be_destroyed
  end

  it 'deletes the topic in the filesystem' do
    dbl = double 'Repository::Asset::Destroy'

    expect(Repository::Asset::Destroy).to receive(:new)
      .with(asset)
      .and_return dbl

    expect(dbl).to receive(:author=).with user

    expect(dbl).to receive :execute

    subject.call asset, user
  end

  describe 'return value' do
    subject { described_class.call asset, user }

    it { is_expected.to be_instance_of Asset }
    it { is_expected.to be_valid }
  end
end
