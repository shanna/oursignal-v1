# vim: syntax=ruby
%w{
  common
  crontab
  db
  feed
  score
}.each do |r|
  require File.join(File.dirname(__FILE__), r)
end

