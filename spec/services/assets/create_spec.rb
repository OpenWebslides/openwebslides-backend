# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assets::Create do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:asset) { build :asset, :topic => create(:topic) }
  let(:user) { build :user }
  let(:file) { File.new Rails.root.join 'spec', 'support', 'asset.png' }

  ##
  # Subject
  #
  ##
  # Stubs and mocks
  #
  before do
    Stub::Command.create Repository::Asset::UpdateFile, %i[author= file=]
  end

  ##
  # Tests
  #
  it 'persists the asset to the database' do
    subject.call asset, user, file

    expect(asset).to be_persisted
  end

  it 'persists the asset to the filesystem' do
    dbl = double 'Repository::Asset::UpdateFile'

    expect(Repository::Asset::UpdateFile).to receive(:new)
      .with(asset)
      .and_return dbl

    expect(dbl).to receive(:author=).with user
    expect(dbl).to receive(:file=).with file.path

    expect(dbl).to receive :execute

    subject.call asset, user, file
  end
end
