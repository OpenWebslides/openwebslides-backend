# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Topic API', :type => :request do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject { response }

  ##
  # Test variables
  #
  let(:user) { create :user, :confirmed }
  let(:topic) { create :topic, :user => user }

  ##
  # Request variables
  #
  let(:title) { Faker::Lorem.words(4).join ' ' }
  let(:attributes) do
    {
      :title => title,
      :access => %i[public protected private].sample,
      :description => Faker::Lorem.words(20).join(' '),
      :rootContentItemId => Faker::Lorem.words(3).join('')
    }
  end

  def create_body(attributes)
    {
      :data => {
        :type => 'topics',
        :attributes => attributes,
        :relationships => {
          :user => {
            :data => {
              :id => user.id,
              :type => 'users'
            }
          }
        }
      }
    }.to_json
  end

  def update_body(id, attributes)
    {
      :data => {
        :type => 'topics',
        :id => id,
        :attributes => attributes
      }
    }.to_json
  end

  ##
  # Tests
  #
  describe 'GET /' do
    before { create_list :topic, 3 }

    before { get topics_path, :headers => headers }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_jsonapi_records Topic.all }
    it { is_expected.to have_jsonapi_record_count 3 }
  end

  describe 'POST /' do
    before { post topics_path, :params => create_body(attrs), :headers => headers(:access) }

    let(:attrs) { attributes }

    it { is_expected.to have_http_status :created }
    it { is_expected.to have_jsonapi_attribute(:title).with_value title }

    context 'when the title is empty' do
      let(:attrs) { attributes.merge :title => '' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when there is no title' do
      let(:attrs) { attributes.except :title }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when access is invalid' do
      let(:attrs) { attributes.merge :access => 'foo' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when there is no access' do
      let(:attrs) { attributes.except :access }

      it { is_expected.to have_http_status :created }
      it { is_expected.to have_jsonapi_attribute(:access).with_value 'public' }
    end
  end

  describe 'GET /:id' do
    before { get topic_path(:id => id), :headers => headers }

    let(:id) { topic.id }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_jsonapi_record topic }

    context 'when the identifier is invalid' do
      let(:id) { 0 }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::RECORD_NOT_FOUND }
    end
  end

  describe 'PUT/PATCH /:id' do
    before { patch topic_path(:id => id), :params => update_body(id, attrs), :headers => headers(:access) }

    let(:id) { topic.id }
    let(:attrs) { attributes.except :rootContentItemId }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_jsonapi_record topic }

    context 'when the identifier is invalid' do
      let(:id) { 0 }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::RECORD_NOT_FOUND }
    end

    context 'when root_content_item_id changes' do
      let(:attrs) { { :rootContentItemId => 'foo' } }

      it { is_expected.to have_http_status :bad_request }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::PARAM_NOT_ALLOWED }
    end
  end

  describe 'DELETE /:id' do
    before { Topics::Create.call topic }

    before { delete topic_path(:id => id), :headers => headers(:access) }

    let(:id) { topic.id }

    it { is_expected.to have_http_status :no_content }

    it 'is destroyed' do
      expect { topic.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    context 'when the identifier is invalid' do
      let(:id) { 0 }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::RECORD_NOT_FOUND }
    end
  end
end
