require File.join(File.dirname(__FILE__), 'helper')
require 'ext/string'

class StringUTF8Test < MerbTest
  context 'String' do
    should 'convert bad GB2312 claim to UTF8' do
      string = '淘宝网 - 淘！我喜欢'
      assert_equal string, string.to_utf8('GB2312')
      assert_equal string, string.to_utf8
    end

    should 'convert UTF-8 to UTF-8' do
      string = 'На берегу пустынных волн'
      assert_equal string, string.to_utf8('utf-8')
      assert_equal string, string.to_utf8
    end
  end
end
