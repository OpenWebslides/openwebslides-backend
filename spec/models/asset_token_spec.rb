# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssetToken, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  subject(:asset_token) { build :asset_token, :subject => user, :object => asset }

  let(:user) { create :user, :confirmed }
  let(:asset) { create :asset, :with_topic }

  describe 'attributes' do
    it { is_expected.to be_a AssetToken }
    it { is_expected.to respond_to :object }
  end

  describe 'methods' do
    # Serialize and deserialize object to let JWT::Auth::Token
    # fill in the defaults for all attributes
    subject(:token) { AssetToken.from_token asset_token.to_jwt }

    describe '#valid?' do
      it { is_expected.to be_valid }

      context 'without token' do
        before { token.object = nil }

        it { is_expected.not_to be_valid }
      end
    end

    describe '#from_token' do
      it { is_expected.to have_attributes :object => asset }
    end
  end
end
