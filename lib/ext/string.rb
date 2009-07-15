module StringToUTF8
  def to_utf8
    valid_encoding? ? encode('utf-8') : force_encoding('utf-8').encode('utf-8')
  end
end
String.send(:include, StringToUTF8)
