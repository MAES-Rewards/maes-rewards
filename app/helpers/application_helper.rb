# frozen_string_literal: true

module ApplicationHelper
    def device
        agent = request.user_agent
        return "mobile" if agent =~ /Mobile/
        return "desktop"
    end
end
