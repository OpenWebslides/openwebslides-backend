# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Content API', :type => :request do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  let(:user) { create :user, :confirmed }
  let(:topic) { create :topic, :user => user }

  let(:message) { Faker::Lorem.words(4).join ' ' }

  ##
  # Request variables
  #
  def content_body(commit_msg = message)
    {
      :data => {
        :type => 'contents',
        :attributes => {
          :message => commit_msg,
          :content => [{
            :id => topic.root_content_item_id,
            :type => 'contentItemTypes/ROOT'
          }]
        }
      }
    }.to_json
  end

  before { Topics::Create.call topic }

  ##
  # Tests
  #
  describe 'GET /' do
    it 'returns topic content' do
      get topic_content_path(:topic_id => topic.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end
  end

  describe 'PUT/PATCH /' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'rejects update when no message is specified' do
      patch topic_content_path(:topic_id => topic.id), :params => content_body(nil), :headers => headers

      expect(response.status).to eq 422
      expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    it 'updates topic content' do
      patch topic_content_path(:topic_id => topic.id), :params => content_body, :headers => headers

      expect(response.status).to eq 204
    end
  end
end
