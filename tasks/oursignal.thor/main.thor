# vim: syntax=ruby
%w{
  common
  feeds
}.each do |r|
  require File.join(File.dirname(__FILE__), r)
end
