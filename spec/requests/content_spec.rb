# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Content API', :type => :request do
  include_context 'repository'

  let(:user) { create :user, :confirmed }
  let(:topic) { create :topic, :user => user }

  def content_body
    {
      :data => {
        :type => 'contents',
        :attributes => {
          :message => 'Update topic content',
          :content => [{
            :id => topic.root_content_item_id,
            :type => 'contentItemTypes/ROOT'
          }]
        }
      }
    }.to_json
  end

  before { Topics::Create.call topic }

  describe 'GET /' do
    before do
    end

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

    it 'updates topic content' do
      patch topic_content_path(:topic_id => topic.id), :params => content_body, :headers => headers

      expect(response.status).to eq 204
    end
  end
end
