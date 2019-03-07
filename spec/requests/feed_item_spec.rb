# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FeedItem API', :type => :request do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject { response }

  ##
  # Test variables
  #
  ##
  # Request variables
  #
  ##
  # Tests
  #
  describe 'GET /' do
    before { get feed_items_path, :headers => headers }

    prepend_before { create_list :feed_item, 3 }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_records FeedItem.all }
    it { is_expected.to have_record_count 3 }
  end
end
