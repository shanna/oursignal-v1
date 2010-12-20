# DO NOT MODIFY THIS FILE
module Bundler
 file = File.expand_path(__FILE__)
 dir = File.dirname(file)

  ENV["PATH"]     = "#{dir}/../../../bin:#{ENV["PATH"]}"
  ENV["RUBYOPT"]  = "-r#{file} #{ENV["RUBYOPT"]}"

  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/abstract-1.0.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/erubis-2.6.5/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/erubis-2.6.5/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/sexp_processor-3.0.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-2.0.17/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-gateway-1.0.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rake-0.8.7/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rake-0.8.7/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/curb-0.6.0.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/curb-0.6.0.0/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-scp-1.0.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/klarlack-0.0.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.2.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.2.0/ext/json/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.2.0/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.2.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/system_timer-1.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/stateless-systems-capistrano-ext-0.18.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/shoulda-2.10.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/shoulda-2.10.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/eventmachine-0.12.10/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-sftp-2.0.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-aggregates-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mailfactory-1.4.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-constraints-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/builder-2.1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.4.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.4.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.4.1/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mime-types-1.16/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/diff-lcs-1.1.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/diff-lcs-1.1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/memcache-client-1.7.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rack-1.0.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rack-1.0.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-types-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/randexp-0.1.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-sweatshop-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/highline-1.5.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/haml-2.2.16/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/haml-2.2.16/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/sax-machine-0.0.15/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-migrations-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-validations-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-1.2.9/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-1.2.9/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/addressable-2.1.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-param-protection-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-auth-core-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-auth-more-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-exceptions-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-timestamps-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/moneta-0.6.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/uri-meta-0.9.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/bundler-0.7.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/extlib-0.9.14/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-core-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-serializer-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-core-1.1.0.pre/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-core-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-mailer-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-assets-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-builder-0.9.8/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-helpers-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb_datamapper-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-slices-1.1.0.pre/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-slices-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby_parser-2.0.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby_parser-2.0.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby2ruby-1.2.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby2ruby-1.2.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/daemons-1.0.10/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-2.5.10/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-2.5.10/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-ext-1.2.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/templater-1.0.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/loofah-0.4.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/data_objects-0.10.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/do_mysql-0.10.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/do_sqlite3-0.10.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/bundler08-0.8.5/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rufus-scheduler-2.0.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activesupport-2.3.5/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/feedzirra-0.0.20/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ZenTest-4.2.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ZenTest-4.2.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/RubyInline-3.8.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ParseTree-3.0.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ParseTree-3.0.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ParseTree-3.0.4/test")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-pre-1.1.0.0/lib")

  @gemfile = "#{dir}/../../../Gemfile"


  def self.require_env(env = nil)
    context = Class.new do
      def initialize(env) @env = env && env.to_s ; end
      def method_missing(*) ; yield if block_given? ; end
      def only(*env)
        old, @only = @only, _combine_only(env.flatten)
        yield
        @only = old
      end
      def except(*env)
        old, @except = @except, _combine_except(env.flatten)
        yield
        @except = old
      end
      def gem(name, *args)
        opt = args.last.is_a?(Hash) ? args.pop : {}
        only = _combine_only(opt[:only] || opt["only"])
        except = _combine_except(opt[:except] || opt["except"])
        files = opt[:require_as] || opt["require_as"] || name
        files = [files] unless files.respond_to?(:each)

        return unless !only || only.any? {|e| e == @env }
        return if except && except.any? {|e| e == @env }

        if files = opt[:require_as] || opt["require_as"]
          files = Array(files)
          files.each { |f| require f }
        else
          begin
            require name
          rescue LoadError
            # Do nothing
          end
        end
        yield if block_given?
        true
      end
      private
      def _combine_only(only)
        return @only unless only
        only = [only].flatten.compact.uniq.map { |o| o.to_s }
        only &= @only if @only
        only
      end
      def _combine_except(except)
        return @except unless except
        except = [except].flatten.compact.uniq.map { |o| o.to_s }
        except |= @except if @except
        except
      end
    end
    context.new(env && env.to_s).instance_eval(File.read(@gemfile), @gemfile, 1)
  end
end

$" << "rubygems.rb"

module Kernel
  def gem(*)
    # Silently ignore calls to gem, since, in theory, everything
    # is activated correctly already.
  end
end

# Define all the Gem errors for gems that reference them.
module Gem
  def self.ruby ; "/usr/bin/ruby1.8" ; end
  def self.dir ; @dir ||= File.dirname(File.expand_path(__FILE__)) ; end
  class << self ; alias default_dir dir; alias path dir ; end
  class LoadError < ::LoadError; end
  class Exception < RuntimeError; end
  class CommandLineError < Exception; end
  class DependencyError < Exception; end
  class DependencyRemovalException < Exception; end
  class GemNotInHomeException < Exception ; end
  class DocumentError < Exception; end
  class EndOfYAMLException < Exception; end
  class FilePermissionError < Exception; end
  class FormatException < Exception; end
  class GemNotFoundException < Exception; end
  class InstallError < Exception; end
  class InvalidSpecificationException < Exception; end
  class OperationNotSupportedError < Exception; end
  class RemoteError < Exception; end
  class RemoteInstallationCancelled < Exception; end
  class RemoteInstallationSkipped < Exception; end
  class RemoteSourceException < Exception; end
  class VerificationError < Exception; end
  class SystemExitException < SystemExit; end
end
