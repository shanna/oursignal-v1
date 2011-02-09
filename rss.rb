#!/usr/bin/env ruby
require './lib/oursignal'
require 'oursignal/job/feed'

Oursignal::Job::Feed.perform 'http://digg.com/news.rss', File.expand_path(File.join(File.dirname(__FILE__), 'tmp', 'rss', '1d081701893a820d332c4cbfabb79e34'))
Oursignal::Job::Feed.perform 'http://news.ycombinator.com/rss', File.expand_path(File.join(File.dirname(__FILE__), 'tmp', 'rss', 'oreilly_radar.atom'))
