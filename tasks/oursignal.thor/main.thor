# vim: syntax=ruby
%w{
  common
  migrate
}.each do |r|
  require File.join(File.dirname(__FILE__), r)
end
