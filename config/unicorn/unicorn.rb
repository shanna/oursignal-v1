require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'oursignal')
require File.join(Oursignal.root, 'config', 'unicorn', 'config')

env     = ENV['RACK_ENV'] || 'development'
options = UNICORN_CONFIG[env.to_sym]

timeout 30

pid              options[:pidfile] if options[:pidfile]
worker_processes options[:workers] if options[:workers]
stderr_path      options[:stderr]  if options[:stderr]
stdout_path      options[:stdout]  if options[:stdout]

listen options[:socket], backlog: options[:backlog] if options.key?(:socket)

if options.key?(:port)
  port = options[:port]
  port = [ port ] unless port.is_a?(Array)
  port.each{|p| listen p, tcp_nopush: true }
end

after_fork do |server,worker|
  Swift.setup(:default, Swift::DB::Postgres, db: 'oursignal')
end

preload_app true
