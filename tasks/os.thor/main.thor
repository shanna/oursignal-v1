# vim: syntax=ruby
%w{
  common
  db
  feed
  score
}.each do |r|
  require File.join(File.dirname(__FILE__), r)
end
