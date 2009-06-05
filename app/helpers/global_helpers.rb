module Merb
  module GlobalHelpers

    def title
      @title ||= 'oursignal'
      [@title].flatten.join(' &raquo; ')
    end

  end
end
