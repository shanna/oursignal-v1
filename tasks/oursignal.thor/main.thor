# vim: syntax=ruby
%w{
  common
  feeds
}.each{|r| require File.join(File.dirname(__FILE__), r)}
