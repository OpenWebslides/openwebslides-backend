# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FeedItem API', :type => :request do
  let(:feed_item) { create :feed_item }

  describe 'GET /' do
    before do
    end

    it 'returns a list of all @feed_items' do
      create :feed_item
      get feed_items_path, :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

      json = JSON.parse response.body
      expect(json).to include 'data'
      expect(json['data']).to be_an Array
      expect(json['data']).not_to be_empty

      feed_item = json['data'].first
      expect(feed_item).to include 'attributes'
      expect(feed_item['attributes']).to include 'feedItemType'
      expect(feed_item['attributes']).to include 'userName'
      expect(feed_item['attributes']).to include 'topicTitle'
      expect(feed_item['meta']).to include 'createdAt'
    end
  end
end
