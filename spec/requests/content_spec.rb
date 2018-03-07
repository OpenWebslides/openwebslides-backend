# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Content API', :type => :request do
  let(:user) { create :user, :confirmed }
  let(:topic) { create :topic, :user => user }

  let(:params) do
    {
      :data => {
        :type => 'contents',
        :attributes => {
          :my_attribute => 'my_value'
        }
      }
    }.to_json
  end

  describe 'GET /' do
    before do
      add_accept_header
    end

    it 'returns topic content' do
      get topic_content_path(:topic_id => topic.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE

      attrs = JSON.parse(response.body)['data']['attributes']

      expect(attrs['content']).not_to be_nil
    end
  end
end
