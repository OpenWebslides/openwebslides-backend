# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  subject(:rating) { create :rating }

  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'associations' do
    it { is_expected.to belong_to(:annotation).inverse_of(:ratings) }
    it { is_expected.to belong_to(:user).inverse_of(:ratings) }

    # shoulda-matchers currently has a bug where the uniqueness scoped to
    # an **association** is not checked properly, and the following test will
    # yield an error. This test is replaced by a custom test
    # TODO: check for progress on the bug, reenable the following test and remove the custom test
    # TODO: https://github.com/thoughtbot/shoulda-matchers/issues/814
    # it { is_expected.to validate_uniqueness_of(:user).scoped_to :annotation}

    it 'is unique over users and annotations' do
      proc = -> { Rating.create! :annotation => rating.annotation, :user => rating.user }
      expect(proc).to raise_error ActiveRecord::RecordInvalid
    end

    context 'when the annotation is locked' do
      before { rating.annotation.flag }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'destroying' do
    context 'when the annotation is locked' do
      before { rating.annotation.flag }

      it 'cannot be destroyed' do
        expect { rating.destroy! }.to raise_error ActiveRecord::RecordNotDestroyed
      end
    end
  end
end
