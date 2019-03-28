# frozen_string_literal: true

module Enums
  class AlertTypeEnum < Enums::BaseEnum
    value 'topic_updated',
          'The topic content was updated'

    value 'pr_submitted',
          'The pull request was submitted'

    value 'pr_accepted',
          'The pull request was accepted'

    value 'pr_rejected',
          'The pull request was rejected'

    value 'topic_forked',
          'The topic was forked'
  end
end
