# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Asset, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:asset) { create :asset, :with_topic }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'attributes' do
    it { is_expected.to validate_presence_of :filename }

    # shoulda-matchers currently has a bug where the uniqueness scoped to
    # an **association** is not checked properly, and the following test will
    # yield an error. This test is replaced by a custom test
    # TODO: check for progress on the bug, reenable the following test and remove the custom test
    # TODO: https://github.com/thoughtbot/shoulda-matchers/issues/814
    # it { is_expected.to validate_uniqueness_of(:filename).scoped_to :topic }

    it 'is unique over topics' do
      proc = -> { Asset.create! :filename => asset.filename, :topic => asset.topic }
      expect(proc).to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:topic).inverse_of(:assets) }
  end
end
