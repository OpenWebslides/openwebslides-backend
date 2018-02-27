# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Conversions API', :type => :request do
  let(:user) { create :user, :confirmed }
  let(:conversion) { create :conversion, :user => user }

  describe 'POST /' do
    before do
      add_auth_header
      @headers['Content-Type'] = 'multipart/form-data'

      @body = {
        :qqfilename => 'presentation.pptx',
        :qqfile => fixture_file_upload(Rails.root.join 'spec', 'support', 'presentation.pptx')
      }
    end

    it 'rejects without qqfilename' do
      post conversions_path, :params => @body.except(:qqfilename), :headers => headers

      expect(response.status).to eq 400
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
    end

    it 'rejects without qqfile' do
      post conversions_path, :params => @body.except(:qqfile), :headers => headers

      expect(response.status).to eq 400
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
    end

    it 'returns successful' do
      post conversions_path, :params => @body, :headers => headers

      expect(response.status).to eq 201
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE

      data = JSON.parse(response.body)['data']
      expect(data['attributes']['name']).to eq 'presentation.pptx'
      expect(data['attributes']['status']).to eq 'queued'
      expect(data['meta']).to include 'createdAt'
    end
  end

  describe 'GET /:id' do
    before do
      add_accept_header
      add_auth_header

      mock_method ConversionWorker, :perform
    end

    it 'rejects an invalid id' do
      get conversion_path(:id => 0), :headers => headers

      expect(response.status).to eq 404
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
    end

    it 'returns successful' do
      get conversion_path(:id => conversion.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE

      data = (JSON.parse response.body)['data']
      expect(Conversion.statuses.keys).to include data['attributes']['status']
      expect(data['meta']).to include 'createdAt'
    end
  end

  # TODO: user relationship
  # TODO: deck relationship
end
