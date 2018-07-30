# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Content API', :type => :request do
  let(:user) { create :user, :confirmed }
  let(:topic) { create :topic, :user => user }

  def content_body
    {
      :data => {
        :type => 'contents',
        :attributes => {
          :content => {
            :foo => 'bar'
          }
        }
      }
    }.to_json
  end

  describe 'GET /' do
    before do
    end

    it 'returns topic content' do
      get topic_content_path(:topic_id => topic.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE

      attrs = JSON.parse(response.body)['data']['attributes']

      expect(attrs['content']).not_to be_nil
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
