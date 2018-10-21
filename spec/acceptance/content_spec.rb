# frozen_string_literal: true

##
# Topic content acceptance test
#
RSpec.describe 'Content', :type => :request do
  ##
  # Configuration
  #
  before do
    OpenWebslides.configure do |config|
      ##
      # Absolute path to persistent repository storage
      #
      config.repository.path = Dir.mktmpdir
    end
  end

  ##
  # Test variables
  #
  let(:user) { create :user, :confirmed }
  let(:topic) { create :topic, :user => user }

  let(:content) do
    root = {
      'id' => topic.root_content_item_id,
      'type' => 'contentItemTypes/ROOT',
      'childItemIds' => ['ivks4jgtxr']
    }
    heading = {
      'id' => 'ivks4jgtxr',
      'type' => 'contentItemTypes/HEADING',
      'text' => 'This is a heading',
      'metadata' => { 'tags' => [], 'visibilityOverrides' => {} },
      'subItemIds' => ['oswmjc09be']
    }
    paragraph = {
      'id' => 'oswmjc09be',
      'type' => 'contentItemTypes/PARAGRAPH',
      'text' => 'This is a paragraph',
      'metadata' => { 'tags' => [], 'visibilityOverrides' => {} },
      'subItemIds' => []
    }

    [root, heading, paragraph]
  end

  ##
  # Tests
  #
  context 'A user' do
    describe 'can retrieve the contents of a topic' do
      let(:topic) { create :topic, :root_content_item_id => 'qyrgv0bcd6' }

      before do
        service = TopicService.new topic

        # Make sure the topic repository is created
        service.create

        # Populate the topic with some dummy content
        service.update :author => user,
                       :content => content,
                       :message => 'Initial commit'
      end

      it 'returns without any errors' do
        headers = {
          'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
        }

        get "/api/topics/#{topic.id}/content", :headers => headers

        expect(response.status).to eq 200
        data = JSON.parse(response.body)['data']['attributes']
        expect(data['content']).to match_array content
      end
    end
  end

  context 'An owner' do
    describe 'can update the contents of a topic' do
      let(:topic) { create :topic, :user => user }

      before do
        service = TopicService.new topic

        # Make sure the topic repository is created
        service.create
      end

      it 'returns without any errors' do
        params = {
          :data => {
            :id => topic.id,
            :type => 'contents',
            :attributes => {
              :message => 'This is a commit',
              :content => content
            }
          }
        }

        headers = {
          'Content-Type' => 'application/vnd.api+json',
          'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}",
          'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
        }

        patch "/api/topics/#{topic.id}/content", :params => params.to_json, :headers => headers

        expect(response.status).to eq 204

        get "/api/topics/#{topic.id}/content", :headers => headers

        expect(response.status).to eq 200
        data = JSON.parse(response.body)['data']['attributes']
        expect(data['content']).to match_array content
      end
    end
  end
end
