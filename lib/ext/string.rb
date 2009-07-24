module StringToUTF8
  def to_utf8
    if respond_to?(:valid_encoding?) # Ruby 1.9
      valid_encoding? ? encode('utf-8') : force_encoding('utf-8').encode('utf-8')
    else
      self
    end
  end
end
String.send(:include, StringToUTF8)
