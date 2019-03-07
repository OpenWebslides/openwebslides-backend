# frozen_string_literal: true

##
# Frontend URL generation helper
#
module WebUrlHelper
  def web_topic_editor_url(topic)
    URI.join(root_url, "/topic/#{topic.id}/editor").to_s
  end

  def web_topic_viewer_url(topic)
    URI.join(root_url, "/topic/#{topic.id}/viewer").to_s
  end
end
