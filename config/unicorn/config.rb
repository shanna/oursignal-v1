UNICORN_CONFIG = {
  development: {
    port:    8080,
    workers: 2,
    pidfile: '/tmp/unicorn-oursignal.pid',
  },
  production: {
    socket:  '/var/run/unicorn-oursignal.sock',
    pidfile: '/var/run/unicorn-oursignal.pid',
    stderr:  '/var/log/unicorn-oursignal.stderr.log',
    stdout:  '/var/log/unicorn-oursignal.stdout.log',
    backlog: 1024,
    workers: 4,
  },
}
