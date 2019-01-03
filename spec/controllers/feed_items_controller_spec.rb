# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedItemsController do
  let(:user) { create :user, :confirmed }
  let(:feed_item) { create :feed_item }

  before do
    allow(controller).to receive(:verify_accept_header_version).and_return true
  end

  describe 'index' do
    context 'unauthenticated' do
      before { get :index }

      it { is_expected.not_to be_protected }
      it { is_expected.not_to return_token }
    end

    context 'authenticated' do
      before do
        add_auth_header
        @request.headers.merge! @headers
        get :index
      end

      it { is_expected.not_to be_protected }
      it { is_expected.to return_token }
    end
  end
end
