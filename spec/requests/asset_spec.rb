# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Assets API', :type => :request do
  include_context 'repository'

  let(:asset) { create :asset, :with_topic }
  let(:topic) { asset.topic }
  let(:user) { topic.user }

  let(:asset_file) { Rails.root.join 'spec', 'support', 'asset.png' }

  describe 'POST /' do
    before do
      add_auth_header
      @headers['Content-Type'] = 'image/png'
      @headers['Content-Disposition'] = 'attachment; filename="asset.png"'

      @body = fixture_file_upload(asset_file)

      allow(Repository::Asset::UpdateFile).to receive :call
    end

    it 'rejects without Content-Disposition' do
      post topic_assets_path(:topic_id => topic.id), :params => @body, :headers => headers.except('Content-Disposition')

      expect(response.status).to eq 400
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    it 'rejects filename already taken' do
      post topic_assets_path(:topic_id => topic.id), :params => @body, :headers => headers.merge('Content-Disposition' => "attachment; filename=\"#{asset.filename}\"")

      expect(response.status).to eq 422
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
      expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
    end

    it 'rejects media types not allowed' do
      post topic_assets_path(:topic_id => topic.id), :params => @body, :headers => headers.merge('Content-Type' => 'application/octet-stream')

      expect(response.status).to eq 415
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    it 'returns successful' do
      post topic_assets_path(:topic_id => topic.id), :params => @body, :headers => headers

      expect(response.status).to eq 201
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

      attributes = (JSON.parse response.body)['data']['attributes']
      expect(attributes['filename']).to eq 'asset.png'
    end
  end

  describe 'GET /:id' do
    before { add_auth_header }

    it 'rejects an invalid id' do
      get asset_path(:id => 0), :headers => headers

      expect(response.status).to eq 404
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    it 'returns successful' do
      get asset_path(:id => asset.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    it 'has a raw link' do
      get asset_path(:id => asset.id), :headers => headers

      links = (JSON.parse response.body)['data']['links']
      expect(links['raw']).not_to be_nil
    end
  end

  describe 'DELETE /:id' do
    before do
      add_auth_header

      allow(Repository::Asset::Delete).to receive :call
    end

    it 'rejects non-existant assets' do
      delete asset_path(:id => '0'), :headers => headers

      asset.reload
      expect(asset).not_to be_destroyed

      expect(response.status).to eq 404
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    it 'deletes an asset' do
      id = asset.id
      delete asset_path(:id => asset.id), :headers => headers

      expect { Asset.find id }.to raise_error ActiveRecord::RecordNotFound

      expect(response.status).to eq 204
    end
  end

  describe 'GET /:id/raw' do
    before do
      @token = Asset::Token.new
      @token.subject = user
      @token.object = asset

      allow(Repository::Asset::Find).to receive(:call).and_return asset_file
    end

    it 'rejects no token' do
      get asset_raw_path(:asset_id => asset.id), :headers => headers

      expect(response.status).to eq 401
    end

    it 'rejects invalid token' do
      get asset_raw_path(:asset_id => asset.id), :params => { :token => 'foo' }, :headers => headers

      expect(response.status).to eq 401
    end

    it 'returns successful' do
      get asset_raw_path(:asset_id => asset.id), :params => { :token => @token.to_jwt }, :headers => headers

      expect(response.status).to eq 200
    end
  end
end
