# frozen_string_literal: true

##
# A short-lived JWT to fetch an asset
#
class AssetToken < JWT::Auth::Token
  attr_accessor :object

  def valid?
    object&.reload
    super && !object.nil?
  end

  def payload
    super.merge :obj => object.id
  end

  def lifetime
    OpenWebslides.config.api.asset_url_lifetime
  end

  def self.from_token(token)
    t = super token

    t.object = Asset.find_by :id => @decoded_payload['obj'] if @decoded_payload['obj']

    t
  end
end
