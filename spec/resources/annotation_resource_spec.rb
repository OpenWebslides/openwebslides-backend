# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnnotationResource, :type => :resource do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:resource) { described_class.new annotation, context }

  ##
  # Test variables
  #
  let(:annotation) { create :annotation }
  let(:context) { {} }

  ##
  # Tests
  #
  it { is_expected.to have_primary_key :id }

  it { is_expected.to have_attribute :content_item_id }
  it { is_expected.to have_attribute :rating }
  it { is_expected.to have_attribute :rated }

  it { is_expected.to have_one :user }
  it { is_expected.to have_one :topic }

  it { is_expected.to have_metadata :created_at => annotation.created_at.to_i.to_s }

  describe 'fields' do
    it 'should have a valid set of fetchable fields' do
      expect(subject.fetchable_fields).to match_array %i[id content_item_id user topic rating rated secret edited flagged deleted]
    end

    it 'should have a valid set of creatable fields' do
      expect(described_class.creatable_fields).to match_array %i[content_item_id user topic]
    end

    it 'should have a valid set of updatable fields' do
      expect(described_class.updatable_fields).to match_array %i[secret]
    end

    it 'should have a valid set of sortable fields' do
      expect(described_class.sortable_fields context).to match_array %i[id content_item_id rating rated secret edited flagged deleted]
    end
  end

  describe 'filters' do
    it 'should have a valid set of filters' do
      expect(described_class.filters.keys).to match_array %i[id user content_item_id rated]
    end
  end
end
