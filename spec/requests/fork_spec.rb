# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Fork API', :type => :request do
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
  ##
  # Test variables
  #
  let(:user) { create :user, :confirmed }
  let(:topic) { create :topic, :user => user }

  ##
  # Tests
  #
  before { Topics::Create.call topic }

  describe 'POST /topics/:id/fork' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'rejects non-existant alerts' do
      post topic_fork_path(:topic_id => 999), :headers => headers

      expect(response.status).to eq 404
      expect(jsonapi_error_code(response)).to eq JSONAPI::RECORD_NOT_FOUND
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    context 'when the topic already has an upstream' do
      let(:topic) { create :topic, :upstream => create(:topic) }

      it 'rejects forking' do
        post topic_fork_path(:topic_id => topic.id), :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
      end
    end

    it 'creates a duplicate topic' do
      post topic_fork_path(:topic_id => topic.id), :headers => headers

      expect(response.status).to eq 201
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end
  end
end
