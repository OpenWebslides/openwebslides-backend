# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordResource, :type => :resource do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  ##
  # Subject
  #
  ##
  # Tests
  #
  it 'is abstract' do
    expect(described_class.abstract).to be true
  end

  describe 'fields' do
    it 'has a valid set of fetchable fields' do
      # Use Resource.fields instead of Resource#fetchable_fields for abstract resources
      expect(described_class.fields).to be_empty
    end

    it 'should have a valid set of creatable fields' do
      expect(described_class.creatable_fields).to match_array %i[email]
    end

    it 'should have a valid set of updatable fields' do
      expect(described_class.updatable_fields).to match_array %i[reset_password_token password]
    end

    it 'has a valid set of sortable fields' do
      expect(described_class.sortable_fields).to be_empty
    end
  end
end
