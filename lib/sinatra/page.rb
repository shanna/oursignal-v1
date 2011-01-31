module Sinatra
  class Base
    module Page
      def page_title default = ''
        content = get_content(:title)
        (content.nil? || content.empty?) ? default : content
      end

      def page_id default = nil
        route = request.path.gsub(%r{^/|/$}, '').split('/').reject{|c| c =~ /^\d+/}.join('_')
        route.empty? ? default : 'page_' + route
      end

      def page_classes *defaults
        classes = request.path.gsub(%r{^/|/$}, '').split('/').reject{|c| c =~ /^\d+/}
        [*defaults, classes].join(' ')
      end
    end # Page

    helpers Page
  end # Base
end # Sinatra
