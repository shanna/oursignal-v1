class String
  module UTF8
    def to_utf8(*args)
      if respond_to?(:valid_encoding?) # Ruby > 1.9.0
        valid_encoding? ? encode('utf-8') : force_encoding('utf-8').encode('utf-8')
      else
        require 'iconv'
        def to_utf8(charset = 'utf-8')
          begin
            Iconv.conv('utf-8', charset || 'utf-8', self)
          rescue Iconv::Failure => error
            charset == 'utf-8' ? nil : to_utf8
          end
        end
        to_utf8(*args)
      end
    end
  end
end
String.send(:include, String::UTF8)
