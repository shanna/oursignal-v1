require 'curb'
require 'forwardable'
require 'stringio'
require 'time'
require 'uri/sanitize'
require 'zlib'

module URI
  class IO < StringIO
    extend Forwardable

    def self.open uri, headers = {}, &block
      new uri, headers, &block
    end

    def initialize uri, headers = {}, &block
      @uri  = URI.sanitize(uri)
      @curl = Curl::Easy.perform(@uri.to_s) do |easy|
        headers.merge('Accept-encoding' => 'gzip').each{|k, v| easy.headers[k] = v}
        block.call(easy) if block_given?
      end

      super force_utf8(body)
    end

    def etag
      @curl.header_str =~ /.*ETag:\s(.*)\r/
      $1
    end

    def last_modified
      @curl.header_str =~ /.*Last-Modified:\s(.*)\r/
      Time.parse($1) if $1
    end

    def_delegator :@curl, :response_code, :status

    protected
      def body
        if @curl.header_str.match(/.*Content-Encoding:\sgzip\r/)
          begin
            gz   = Zlib::GzipReader.new(StringIO.new(@curl.body_str))
            body = gz.read
            gz.close
            body
          rescue Zlib::GzipFile::Error
            @curl.body_str
          end
        else
          @curl.body_str
        end
      end

      #--
      # TODO: Steal code from https://github.com/stateless-systems/metauri/blob/master/lib/metauri/location/resolve.rb
      def force_utf8 raw
        options = {invalid: :replace, undef: :replace}
        raw.valid_encoding? ? raw.encode('utf-8', options) : raw.force_encoding('utf-8').encode('utf-8', options)
      rescue => error
        warn error.message
        ''
      end
  end # IO
end # URI
