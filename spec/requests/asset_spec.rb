# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Assets API', :type => :request do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # Stubs and mocks
  #
  before do
    allow(Repo::Asset::UpdateFile).to receive :call
    allow(Repo::Asset::Delete).to receive :call
  end

  ##
  # Subject
  #
  subject { response }

  ##
  # Test variables
  #
  let(:asset) { create :asset, :with_topic }

  let(:topic) { asset.topic }
  let(:user) { topic.user }

  let(:asset_file) { Rails.root.join 'spec', 'support', 'asset.png' }

  ##
  # Request variables
  #
  let(:body) { fixture_file_upload asset_file }

  ##
  # Tests
  #
  describe 'POST /' do
    before { post topic_assets_path(:topic_id => topic.id), :params => body, :headers => asset_headers }

    let(:asset_headers) { headers(:access).merge 'Content-Type' => content_type, 'Content-Disposition' => "attachment; filename=\"#{filename}\"" }
    let(:filename) { 'asset.png' }
    let(:content_type) { 'image/png' }

    it { is_expected.to have_http_status :created }
    it { is_expected.to have_jsonapi_attribute(:filename).with_value 'asset.png' }

    context 'when Content-Disposition is omitted' do
      let(:asset_headers) { headers(:access).merge 'Content-Type' => 'image/png' }

      it { is_expected.to have_http_status :bad_request }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::BAD_REQUEST }
    end

    context 'when the filename is already taken' do
      let(:filename) { asset.filename }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when the media type is not allowed' do
      let(:content_type) { 'application/octet-stream' }

      it { is_expected.to have_http_status :unsupported_media_type }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::UNSUPPORTED_MEDIA_TYPE }
    end
  end

  describe 'GET /:id' do
    before { get asset_path(:id => id), :headers => headers(:access) }

    let(:id) { asset.id }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_jsonapi_record asset }

    context 'when the identifier is invalid' do
      let(:id) { 0 }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::RECORD_NOT_FOUND }
    end

    it 'has a raw link' do
      links = (JSON.parse response.body)['data']['links']
      expect(links['raw']).not_to be_nil
    end
  end

  describe 'DELETE /:id' do
    before { delete asset_path(:id => id), :headers => headers(:access) }

    let(:id) { asset.id }

    it { is_expected.to have_http_status :no_content }

    it 'is deleted' do
      expect { asset.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    context 'when the identifier is invalid' do
      let(:id) { 0 }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::RECORD_NOT_FOUND }
    end
  end
end
