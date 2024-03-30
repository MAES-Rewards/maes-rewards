# frozen_string_literal: true

module ApplicationHelper
  def device
    agent = request.user_agent
    return 'desktop' if agent.nil?
    return 'mobile' if agent.include?('Mobile')

    'desktop'
  end
end
