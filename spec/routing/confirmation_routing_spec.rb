# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'confirmation routing', :type => :routing do
  it 'routes confirmation endpoint' do
    route = '/api/confirmation'

    expect(:get => route).not_to be_routable
    expect(:patch => route).to route_to 'confirmation#update'
    expect(:put => route).to route_to 'confirmation#update'
    expect(:post => route).to route_to 'confirmation#create'
    expect(:delete => route).not_to be_routable
  end
end
