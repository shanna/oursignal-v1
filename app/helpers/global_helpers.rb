module Merb
  module GlobalHelpers

    def title
      @title ||= 'oursignal'
      [@title].flatten.join(' &raquo; ')
    end

    def messages_for(errors)
      error_messages_for errors, :header => ''
    end

    def messages(messages = message)
      (messages ||= {}).map do |k, v|
        tag('div', tag('ul', tag('li', v)), {:id => k})
      end.join
    end

  end
end
