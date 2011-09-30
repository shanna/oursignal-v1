require File.join(File.dirname(__FILE__), '..', 'oursignal')
require 'resque'
require 'resque/plugins/lock'
require 'logger'

# TODO: Weird loading order causes superclass mismatch in oursignal/score without this.
require 'oursignal/score'

# Jobs.
require 'oursignal/job/feed'
require 'oursignal/job/score'
require 'oursignal/job/timestep'
require 'oursignal/job/update'

Resque.after_fork{ Swift.db.reconnect}

module Oursignal
  module Job
  end # Job
end # Oursignal
