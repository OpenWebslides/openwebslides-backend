# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConfirmationResource, :type => :resource do
  it 'is abstract' do
    expect(described_class.abstract).to be true
  end

  describe 'fields' do
    it 'has a valid set of fields' do
      expect(described_class.fields).to match_array %i[id confirmation_token email]
    end

    it 'has a valid set of creatable fields' do
      expect(described_class.creatable_fields).to match_array %i[email]
    end

    it 'has a valid set of updatable fields' do
      expect(described_class.updatable_fields).to match_array %i[confirmation_token]
    end
  end
end
