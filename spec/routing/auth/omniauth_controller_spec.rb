# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'omniauth routing', :type => :routing do
  it 'routes omniauth callback' do
    params = { :controller => 'oauth/omniauth', :action => 'callback', :provider => 'provider' }
    expect(:get => '/oauth/provider/callback').to route_to params
  end
end
