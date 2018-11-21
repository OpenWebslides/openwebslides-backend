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

  def web_conversation_url(conversation)
    URI.join(web_topic_viewer_url conversation.topic).to_s
  end

  def web_comment_url(comment)
    URI.join(web_topic_viewer_url comment.topic).to_s
  end
end
