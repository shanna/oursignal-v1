require 'curb'

class Recaptcha
  class Response
    attr_reader :success, :message
    def initialize(response)
      response = response.split("\n")
      @success = response[0] =~ /true/
      @message = response[1].strip
    end

    def errors
      success ? [] : [[:captcha, 'fail']] # TODO: A better generic message.
    end
  end

  def initialize(private_key, options = {})
    @curl        = Curl::Easy.new('http://api-verify.recaptcha.net/verify')
    @private_key = private_key
    default      = {
      :headers => {'User-Agent' => 'oursignal/2 +oursignal.com'},
      :timeout => 10
    }.update(options)
    default.each{|k, v| @curl.send("#{k}=", v)}
  end

  def verify(remoteip, challenge, response)
    @curl.http_post(
      Curl::PostField.content('remoteip', remoteip),
      Curl::PostField.content('challenge', challenge),
      Curl::PostField.content('response', response),
      Curl::PostField.content('privatekey', @private_key)
    )
    Response.new(@curl.body_str)
  end
end

