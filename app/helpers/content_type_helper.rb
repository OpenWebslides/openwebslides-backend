# frozen_string_literal: true

##
# Content Type helper
#
module ContentTypeHelper
  def content_type_for(filename)
    Mime::Type.lookup_by_extension(File.extname(filename)[1..-1])&.to_s
  end
end
