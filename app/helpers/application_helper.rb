# frozen_string_literal: true

module ApplicationHelper
  def device
    agent = request.user_agent
    if agent == nil
        return 'desktop'
    end
    return 'mobile' if agent.include?('Mobile')

    'desktop'
  end
end
