# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pull Request API', :type => :request do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  let(:pull_request) { create :pull_request }

  let(:user) { create :user, :confirmed }

  before do
    pull_request.source.collaborators << user
    pull_request.target.collaborators << user
  end

  ##
  # Request
  #
  let(:attributes) do
    {
      :message => Faker::Lorem.words(20).join(' ')
    }
  end

  def request_body(attributes)
    {
      :data => {
        :type => 'pullRequests',
        :attributes => attributes,
        :relationships => {
          :user => {
            :data => {
              :id => user.id,
              :type => 'users'
            }
          },
          :source => {
            :data => {
              :id => pull_request.source.id,
              :type => 'topics'
            }
          },
          :target => {
            :data => {
              :id => pull_request.target.id,
              :type => 'topics'
            }
          }
        }
      }
    }.to_json
  end

  ##
  # Tests
  #
  describe 'POST /' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'rejects empty message' do
      post pull_requests_path, :params => request_body(attributes.merge :message => ''), :headers => headers

      expect(response.status).to eq 422
      expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    context 'when the source does not have an upstream' do
      before { pull_request.source.update :upstream => nil }

      it 'rejects' do
        post pull_requests_path, :params => request_body(attributes), :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
      end
    end

    context 'when the source has an upstream not equal to the target' do
      before { pull_request.source.update :upstream => create(:topic) }

      it 'rejects' do
        post pull_requests_path, :params => request_body(attributes), :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
      end
    end

    it 'returns successful' do
      post pull_requests_path, :params => request_body(attributes), :headers => headers

      expect(response.status).to eq 201
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

      json = JSON.parse response.body

      expect(json['data']['attributes']['message']).to eq attributes[:message]
    end
  end

  describe 'GET /:id' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'rejects an invalid id' do
      get pull_request_path(:id => 0), :headers => headers

      expect(response.status).to eq 404
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    it 'returns successful' do
      get pull_request_path(:id => pull_request.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end
  end

  describe 'GET /incomingPullRequests' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'returns successful' do
      get topic_incomingPullRequests_path(:topic_id => pull_request.target.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

      json = JSON.parse response.body
      expect(json['data'].count).to eq 1
    end
  end

  describe 'GET /outgoingPullRequests' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'returns successful' do
      get topic_outgoingPullRequests_path(:topic_id => pull_request.source.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

      json = JSON.parse response.body
      expect(json['data'].count).to eq 1
    end
  end
end
