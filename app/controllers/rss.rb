require 'digg'

class Rss < Application
  only_provides :rss

  def digg
    http_max_age 5.minutes
    render ::Digg.read.to_s, :format => :rss
  end
end
