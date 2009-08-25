require File.join(File.dirname(__FILE__), 'common')

# TODO: This is generic enough that 'most' applications should have some sort of crontab.
# Create something in ss-capistrano-ext.
module Os
  class Crontab < Thor
    def self.new(*args)
      Oursignal.merb_env
      super(*args)
    end

    desc 'redeploy', '(Re)deploy oursignal crontab for current environment.'
    def redeploy
      require 'erubis'
      thor  = "cd #{Oursignal.root} && MERB_ENV=#{Merb.environment} #{Oursignal.root}/bin/thor"
      tmpl  = File.read(File.join(File.dirname(__FILE__), 'crontab.erb'))
      eruby = Erubis::Eruby.new(tmpl)

      File.open('/etc/cron.d/oursignal', File::CREAT | File::TRUNC | File::WRONLY) do |f|
        f.write eruby.result(:thor => thor)
      end
    end
  end
end

