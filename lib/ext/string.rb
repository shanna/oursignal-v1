class String
  module UTF8
    UTF8 = 'utf-8'.freeze

    def to_utf8(*args)
      if respond_to?(:valid_encoding?) # Ruby > 1.9.0
        valid_encoding? ? encode(UTF8) : force_encoding(UTF8).encode(UTF8)
      else
        require 'iconv'
        def to_utf8(charset = UTF8)
          begin
            Iconv.conv(UTF8, charset || UTF8, self)
          rescue Iconv::Failure => error
            charset == UTF8 ? nil : to_utf8
          end
        end
        to_utf8(*args)
      end
    end
  end
end
String.send(:include, String::UTF8)
