# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Asset, :type => :model do
  let(:asset) { create :asset, :with_topic }
  let(:topic) { create :topic }

  describe 'attributes' do
    it { is_expected.not_to allow_value(nil).for(:filename) }
    it { is_expected.not_to allow_value('').for(:filename) }

    it 'is invalid without attributes' do
      expect(subject).not_to be_valid
    end

    it 'is valid with attributes' do
      expect(asset).to be_valid
    end

    it 'is unique over topics' do
      proc = -> { Asset.create! :filename => asset.filename, :topic => asset.topic }
      expect(proc).to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:topic).inverse_of(:assets) }
  end
end
