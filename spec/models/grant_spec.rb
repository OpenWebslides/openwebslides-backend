# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Grant, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:grant) { create :grant }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:topic) }

    # shoulda-matchers currently has a bug where the uniqueness scoped to
    # an **association** is not checked properly, and the following test will
    # yield an error. This test is replaced by a custom test
    # TODO: check for progress on the bug, reenable the following test and remove the custom test
    # TODO: https://github.com/thoughtbot/shoulda-matchers/issues/814
    # it { is_expected.to validate_uniqueness_of(:topics).scoped_to :user }

    it 'is unique over topics and users' do
      proc = -> { Grant.create! :topic => grant.topic, :user => grant.user }
      expect(proc).to raise_error ActiveRecord::RecordInvalid
    end
  end
end
