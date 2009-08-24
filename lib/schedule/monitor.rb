require 'schedule'
require 'evma_httpserver' # stupid name

module Schedule
  class Monitor < EventMachine::Connection
    include EventMachine::HttpServer

    def process_http_request
      response  = EventMachine::DelegatedHttpResponse.new(self)
      response.content_type 'text/plain'
      response.status  = 200
      response.content = monitor rescue $!.inspect
      response.send_response
    end

    def self.run(host = '0.0.0.0', port = '4500')
      Schedule.run do
        puts " ~ Starting schedule monitor on #{host}:#{port}..."
        EM.start_server host, port, self
      end
    end

    protected
      def monitor
        result = StringIO.new
        Schedule.run.jobs.each do |job_id, job|
          last  = job.last.blank? ? '' : (Time.at(job.last.to_i).to_s rescue job.last)
          result.puts(
            job_id,
            "  class:  #{job.block.class}",
            "  tags:   #{job.tags.join(', ')}",
            "  last:   #{last}",
            "  t:      #{job.t}",
            ''
          )
        end
        result.rewind
        result.read
      end
  end # Monitor
end # Schedule
