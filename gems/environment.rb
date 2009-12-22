# DO NOT MODIFY THIS FILE
module Bundler
 file = File.expand_path(__FILE__)
 dir = File.dirname(file)

  ENV["PATH"]     = "#{dir}/../bin:#{ENV["PATH"]}"
  ENV["RUBYOPT"]  = "-r#{file} #{ENV["RUBYOPT"]}"

  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/abstract-1.0.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/abstract-1.0.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-2.0.17/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-2.0.17/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-gateway-1.0.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-gateway-1.0.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/sexp_processor-3.0.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/sexp_processor-3.0.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/erubis-2.6.5/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/erubis-2.6.5/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/curb-0.6.0.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/curb-0.6.0.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/curb-0.6.0.0/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rake-0.8.7/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rake-0.8.7/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-scp-1.0.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-scp-1.0.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/klarlack-0.0.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/klarlack-0.0.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.2.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.2.0/ext/json/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.2.0/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.2.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/system_timer-1.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/system_timer-1.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/stateless-systems-capistrano-ext-0.12.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/stateless-systems-capistrano-ext-0.12.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/shoulda-2.10.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/shoulda-2.10.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/eventmachine-0.12.10/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/eventmachine-0.12.10/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-sftp-2.0.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-sftp-2.0.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-aggregates-0.10.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-aggregates-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mailfactory-1.4.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mailfactory-1.4.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/builder-2.1.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/builder-2.1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-constraints-0.10.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-constraints-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.4.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.4.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.4.1/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mime-types-1.16/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mime-types-1.16/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/diff-lcs-1.1.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/diff-lcs-1.1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/memcache-client-1.7.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/memcache-client-1.7.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rack-1.0.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rack-1.0.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-types-0.10.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-types-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/randexp-0.1.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/randexp-0.1.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-sweatshop-0.10.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-sweatshop-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/highline-1.5.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/highline-1.5.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/haml-2.2.16/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/haml-2.2.16/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/sax-machine-0.0.15/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/sax-machine-0.0.15/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-migrations-0.10.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-migrations-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-validations-0.10.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-validations-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-timestamps-0.10.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-timestamps-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/moneta-0.6.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/moneta-0.6.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/uri-meta-0.9.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/uri-meta-0.9.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/bundler-0.7.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/bundler-0.7.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-1.2.9/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-1.2.9/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/addressable-2.1.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/addressable-2.1.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-param-protection-1.1.0.pre/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-param-protection-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-auth-core-1.1.0.pre/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-auth-core-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-auth-more-1.1.0.pre/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-auth-more-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-exceptions-1.1.0.pre/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-exceptions-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/extlib-0.9.14/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/extlib-0.9.14/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-core-0.10.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-core-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-serializer-0.10.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/dm-serializer-0.10.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-core-1.1.0.pre/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-core-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-mailer-1.1.0.pre/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-mailer-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-assets-1.1.0.pre/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-assets-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-builder-0.9.8/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-builder-0.9.8/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-helpers-1.1.0.pre/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-helpers-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb_datamapper-1.1.0.pre/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb_datamapper-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-slices-1.1.0.pre/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-slices-1.1.0.pre/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby_parser-2.0.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby_parser-2.0.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby2ruby-1.2.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby2ruby-1.2.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/daemons-1.0.10/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/daemons-1.0.10/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-2.5.10/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-2.5.10/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-ext-1.2.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-ext-1.2.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/templater-1.0.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/templater-1.0.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/loofah-0.4.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/loofah-0.4.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ZenTest-4.2.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ZenTest-4.2.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/RubyInline-3.8.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/RubyInline-3.8.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ParseTree-3.0.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ParseTree-3.0.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ParseTree-3.0.4/test")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/data_objects-0.10.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/data_objects-0.10.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/do_mysql-0.10.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/do_mysql-0.10.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/do_sqlite3-0.10.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/do_sqlite3-0.10.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-pre-1.1.0.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/merb-pre-1.1.0.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rufus-scheduler-2.0.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rufus-scheduler-2.0.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activesupport-2.3.5/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activesupport-2.3.5/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/feedzirra-0.0.20/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/feedzirra-0.0.20/lib")

  @gemfile = "#{dir}/../Gemfile"

  require "rubygems"

  @bundled_specs = {}
  @bundled_specs["abstract"] = eval(File.read("#{dir}/specifications/abstract-1.0.0.gemspec"))
  @bundled_specs["abstract"].loaded_from = "#{dir}/specifications/abstract-1.0.0.gemspec"
  @bundled_specs["net-ssh"] = eval(File.read("#{dir}/specifications/net-ssh-2.0.17.gemspec"))
  @bundled_specs["net-ssh"].loaded_from = "#{dir}/specifications/net-ssh-2.0.17.gemspec"
  @bundled_specs["net-ssh-gateway"] = eval(File.read("#{dir}/specifications/net-ssh-gateway-1.0.1.gemspec"))
  @bundled_specs["net-ssh-gateway"].loaded_from = "#{dir}/specifications/net-ssh-gateway-1.0.1.gemspec"
  @bundled_specs["sexp_processor"] = eval(File.read("#{dir}/specifications/sexp_processor-3.0.3.gemspec"))
  @bundled_specs["sexp_processor"].loaded_from = "#{dir}/specifications/sexp_processor-3.0.3.gemspec"
  @bundled_specs["erubis"] = eval(File.read("#{dir}/specifications/erubis-2.6.5.gemspec"))
  @bundled_specs["erubis"].loaded_from = "#{dir}/specifications/erubis-2.6.5.gemspec"
  @bundled_specs["curb"] = eval(File.read("#{dir}/specifications/curb-0.6.0.0.gemspec"))
  @bundled_specs["curb"].loaded_from = "#{dir}/specifications/curb-0.6.0.0.gemspec"
  @bundled_specs["rake"] = eval(File.read("#{dir}/specifications/rake-0.8.7.gemspec"))
  @bundled_specs["rake"].loaded_from = "#{dir}/specifications/rake-0.8.7.gemspec"
  @bundled_specs["net-scp"] = eval(File.read("#{dir}/specifications/net-scp-1.0.2.gemspec"))
  @bundled_specs["net-scp"].loaded_from = "#{dir}/specifications/net-scp-1.0.2.gemspec"
  @bundled_specs["klarlack"] = eval(File.read("#{dir}/specifications/klarlack-0.0.3.gemspec"))
  @bundled_specs["klarlack"].loaded_from = "#{dir}/specifications/klarlack-0.0.3.gemspec"
  @bundled_specs["json"] = eval(File.read("#{dir}/specifications/json-1.2.0.gemspec"))
  @bundled_specs["json"].loaded_from = "#{dir}/specifications/json-1.2.0.gemspec"
  @bundled_specs["system_timer"] = eval(File.read("#{dir}/specifications/system_timer-1.0.gemspec"))
  @bundled_specs["system_timer"].loaded_from = "#{dir}/specifications/system_timer-1.0.gemspec"
  @bundled_specs["stateless-systems-capistrano-ext"] = eval(File.read("#{dir}/specifications/stateless-systems-capistrano-ext-0.12.0.gemspec"))
  @bundled_specs["stateless-systems-capistrano-ext"].loaded_from = "#{dir}/specifications/stateless-systems-capistrano-ext-0.12.0.gemspec"
  @bundled_specs["shoulda"] = eval(File.read("#{dir}/specifications/shoulda-2.10.2.gemspec"))
  @bundled_specs["shoulda"].loaded_from = "#{dir}/specifications/shoulda-2.10.2.gemspec"
  @bundled_specs["eventmachine"] = eval(File.read("#{dir}/specifications/eventmachine-0.12.10.gemspec"))
  @bundled_specs["eventmachine"].loaded_from = "#{dir}/specifications/eventmachine-0.12.10.gemspec"
  @bundled_specs["net-sftp"] = eval(File.read("#{dir}/specifications/net-sftp-2.0.4.gemspec"))
  @bundled_specs["net-sftp"].loaded_from = "#{dir}/specifications/net-sftp-2.0.4.gemspec"
  @bundled_specs["dm-aggregates"] = eval(File.read("#{dir}/specifications/dm-aggregates-0.10.1.gemspec"))
  @bundled_specs["dm-aggregates"].loaded_from = "#{dir}/specifications/dm-aggregates-0.10.1.gemspec"
  @bundled_specs["mailfactory"] = eval(File.read("#{dir}/specifications/mailfactory-1.4.0.gemspec"))
  @bundled_specs["mailfactory"].loaded_from = "#{dir}/specifications/mailfactory-1.4.0.gemspec"
  @bundled_specs["builder"] = eval(File.read("#{dir}/specifications/builder-2.1.2.gemspec"))
  @bundled_specs["builder"].loaded_from = "#{dir}/specifications/builder-2.1.2.gemspec"
  @bundled_specs["dm-constraints"] = eval(File.read("#{dir}/specifications/dm-constraints-0.10.1.gemspec"))
  @bundled_specs["dm-constraints"].loaded_from = "#{dir}/specifications/dm-constraints-0.10.1.gemspec"
  @bundled_specs["nokogiri"] = eval(File.read("#{dir}/specifications/nokogiri-1.4.1.gemspec"))
  @bundled_specs["nokogiri"].loaded_from = "#{dir}/specifications/nokogiri-1.4.1.gemspec"
  @bundled_specs["mime-types"] = eval(File.read("#{dir}/specifications/mime-types-1.16.gemspec"))
  @bundled_specs["mime-types"].loaded_from = "#{dir}/specifications/mime-types-1.16.gemspec"
  @bundled_specs["diff-lcs"] = eval(File.read("#{dir}/specifications/diff-lcs-1.1.2.gemspec"))
  @bundled_specs["diff-lcs"].loaded_from = "#{dir}/specifications/diff-lcs-1.1.2.gemspec"
  @bundled_specs["memcache-client"] = eval(File.read("#{dir}/specifications/memcache-client-1.7.4.gemspec"))
  @bundled_specs["memcache-client"].loaded_from = "#{dir}/specifications/memcache-client-1.7.4.gemspec"
  @bundled_specs["rack"] = eval(File.read("#{dir}/specifications/rack-1.0.1.gemspec"))
  @bundled_specs["rack"].loaded_from = "#{dir}/specifications/rack-1.0.1.gemspec"
  @bundled_specs["dm-types"] = eval(File.read("#{dir}/specifications/dm-types-0.10.1.gemspec"))
  @bundled_specs["dm-types"].loaded_from = "#{dir}/specifications/dm-types-0.10.1.gemspec"
  @bundled_specs["randexp"] = eval(File.read("#{dir}/specifications/randexp-0.1.4.gemspec"))
  @bundled_specs["randexp"].loaded_from = "#{dir}/specifications/randexp-0.1.4.gemspec"
  @bundled_specs["dm-sweatshop"] = eval(File.read("#{dir}/specifications/dm-sweatshop-0.10.1.gemspec"))
  @bundled_specs["dm-sweatshop"].loaded_from = "#{dir}/specifications/dm-sweatshop-0.10.1.gemspec"
  @bundled_specs["highline"] = eval(File.read("#{dir}/specifications/highline-1.5.1.gemspec"))
  @bundled_specs["highline"].loaded_from = "#{dir}/specifications/highline-1.5.1.gemspec"
  @bundled_specs["haml"] = eval(File.read("#{dir}/specifications/haml-2.2.16.gemspec"))
  @bundled_specs["haml"].loaded_from = "#{dir}/specifications/haml-2.2.16.gemspec"
  @bundled_specs["sax-machine"] = eval(File.read("#{dir}/specifications/sax-machine-0.0.15.gemspec"))
  @bundled_specs["sax-machine"].loaded_from = "#{dir}/specifications/sax-machine-0.0.15.gemspec"
  @bundled_specs["dm-migrations"] = eval(File.read("#{dir}/specifications/dm-migrations-0.10.1.gemspec"))
  @bundled_specs["dm-migrations"].loaded_from = "#{dir}/specifications/dm-migrations-0.10.1.gemspec"
  @bundled_specs["dm-validations"] = eval(File.read("#{dir}/specifications/dm-validations-0.10.1.gemspec"))
  @bundled_specs["dm-validations"].loaded_from = "#{dir}/specifications/dm-validations-0.10.1.gemspec"
  @bundled_specs["dm-timestamps"] = eval(File.read("#{dir}/specifications/dm-timestamps-0.10.1.gemspec"))
  @bundled_specs["dm-timestamps"].loaded_from = "#{dir}/specifications/dm-timestamps-0.10.1.gemspec"
  @bundled_specs["moneta"] = eval(File.read("#{dir}/specifications/moneta-0.6.0.gemspec"))
  @bundled_specs["moneta"].loaded_from = "#{dir}/specifications/moneta-0.6.0.gemspec"
  @bundled_specs["uri-meta"] = eval(File.read("#{dir}/specifications/uri-meta-0.9.4.gemspec"))
  @bundled_specs["uri-meta"].loaded_from = "#{dir}/specifications/uri-meta-0.9.4.gemspec"
  @bundled_specs["bundler"] = eval(File.read("#{dir}/specifications/bundler-0.7.2.gemspec"))
  @bundled_specs["bundler"].loaded_from = "#{dir}/specifications/bundler-0.7.2.gemspec"
  @bundled_specs["rspec"] = eval(File.read("#{dir}/specifications/rspec-1.2.9.gemspec"))
  @bundled_specs["rspec"].loaded_from = "#{dir}/specifications/rspec-1.2.9.gemspec"
  @bundled_specs["addressable"] = eval(File.read("#{dir}/specifications/addressable-2.1.1.gemspec"))
  @bundled_specs["addressable"].loaded_from = "#{dir}/specifications/addressable-2.1.1.gemspec"
  @bundled_specs["merb-param-protection"] = eval(File.read("#{dir}/specifications/merb-param-protection-1.1.0.pre.gemspec"))
  @bundled_specs["merb-param-protection"].loaded_from = "#{dir}/specifications/merb-param-protection-1.1.0.pre.gemspec"
  @bundled_specs["merb-auth-core"] = eval(File.read("#{dir}/specifications/merb-auth-core-1.1.0.pre.gemspec"))
  @bundled_specs["merb-auth-core"].loaded_from = "#{dir}/specifications/merb-auth-core-1.1.0.pre.gemspec"
  @bundled_specs["merb-auth-more"] = eval(File.read("#{dir}/specifications/merb-auth-more-1.1.0.pre.gemspec"))
  @bundled_specs["merb-auth-more"].loaded_from = "#{dir}/specifications/merb-auth-more-1.1.0.pre.gemspec"
  @bundled_specs["merb-exceptions"] = eval(File.read("#{dir}/specifications/merb-exceptions-1.1.0.pre.gemspec"))
  @bundled_specs["merb-exceptions"].loaded_from = "#{dir}/specifications/merb-exceptions-1.1.0.pre.gemspec"
  @bundled_specs["extlib"] = eval(File.read("#{dir}/specifications/extlib-0.9.14.gemspec"))
  @bundled_specs["extlib"].loaded_from = "#{dir}/specifications/extlib-0.9.14.gemspec"
  @bundled_specs["dm-core"] = eval(File.read("#{dir}/specifications/dm-core-0.10.1.gemspec"))
  @bundled_specs["dm-core"].loaded_from = "#{dir}/specifications/dm-core-0.10.1.gemspec"
  @bundled_specs["dm-serializer"] = eval(File.read("#{dir}/specifications/dm-serializer-0.10.1.gemspec"))
  @bundled_specs["dm-serializer"].loaded_from = "#{dir}/specifications/dm-serializer-0.10.1.gemspec"
  @bundled_specs["merb-core"] = eval(File.read("#{dir}/specifications/merb-core-1.1.0.pre.gemspec"))
  @bundled_specs["merb-core"].loaded_from = "#{dir}/specifications/merb-core-1.1.0.pre.gemspec"
  @bundled_specs["merb-mailer"] = eval(File.read("#{dir}/specifications/merb-mailer-1.1.0.pre.gemspec"))
  @bundled_specs["merb-mailer"].loaded_from = "#{dir}/specifications/merb-mailer-1.1.0.pre.gemspec"
  @bundled_specs["merb-assets"] = eval(File.read("#{dir}/specifications/merb-assets-1.1.0.pre.gemspec"))
  @bundled_specs["merb-assets"].loaded_from = "#{dir}/specifications/merb-assets-1.1.0.pre.gemspec"
  @bundled_specs["merb-builder"] = eval(File.read("#{dir}/specifications/merb-builder-0.9.8.gemspec"))
  @bundled_specs["merb-builder"].loaded_from = "#{dir}/specifications/merb-builder-0.9.8.gemspec"
  @bundled_specs["merb-helpers"] = eval(File.read("#{dir}/specifications/merb-helpers-1.1.0.pre.gemspec"))
  @bundled_specs["merb-helpers"].loaded_from = "#{dir}/specifications/merb-helpers-1.1.0.pre.gemspec"
  @bundled_specs["merb_datamapper"] = eval(File.read("#{dir}/specifications/merb_datamapper-1.1.0.pre.gemspec"))
  @bundled_specs["merb_datamapper"].loaded_from = "#{dir}/specifications/merb_datamapper-1.1.0.pre.gemspec"
  @bundled_specs["merb-slices"] = eval(File.read("#{dir}/specifications/merb-slices-1.1.0.pre.gemspec"))
  @bundled_specs["merb-slices"].loaded_from = "#{dir}/specifications/merb-slices-1.1.0.pre.gemspec"
  @bundled_specs["ruby_parser"] = eval(File.read("#{dir}/specifications/ruby_parser-2.0.4.gemspec"))
  @bundled_specs["ruby_parser"].loaded_from = "#{dir}/specifications/ruby_parser-2.0.4.gemspec"
  @bundled_specs["ruby2ruby"] = eval(File.read("#{dir}/specifications/ruby2ruby-1.2.4.gemspec"))
  @bundled_specs["ruby2ruby"].loaded_from = "#{dir}/specifications/ruby2ruby-1.2.4.gemspec"
  @bundled_specs["daemons"] = eval(File.read("#{dir}/specifications/daemons-1.0.10.gemspec"))
  @bundled_specs["daemons"].loaded_from = "#{dir}/specifications/daemons-1.0.10.gemspec"
  @bundled_specs["capistrano"] = eval(File.read("#{dir}/specifications/capistrano-2.5.10.gemspec"))
  @bundled_specs["capistrano"].loaded_from = "#{dir}/specifications/capistrano-2.5.10.gemspec"
  @bundled_specs["capistrano-ext"] = eval(File.read("#{dir}/specifications/capistrano-ext-1.2.1.gemspec"))
  @bundled_specs["capistrano-ext"].loaded_from = "#{dir}/specifications/capistrano-ext-1.2.1.gemspec"
  @bundled_specs["templater"] = eval(File.read("#{dir}/specifications/templater-1.0.0.gemspec"))
  @bundled_specs["templater"].loaded_from = "#{dir}/specifications/templater-1.0.0.gemspec"
  @bundled_specs["loofah"] = eval(File.read("#{dir}/specifications/loofah-0.4.1.gemspec"))
  @bundled_specs["loofah"].loaded_from = "#{dir}/specifications/loofah-0.4.1.gemspec"
  @bundled_specs["ZenTest"] = eval(File.read("#{dir}/specifications/ZenTest-4.2.1.gemspec"))
  @bundled_specs["ZenTest"].loaded_from = "#{dir}/specifications/ZenTest-4.2.1.gemspec"
  @bundled_specs["RubyInline"] = eval(File.read("#{dir}/specifications/RubyInline-3.8.4.gemspec"))
  @bundled_specs["RubyInline"].loaded_from = "#{dir}/specifications/RubyInline-3.8.4.gemspec"
  @bundled_specs["ParseTree"] = eval(File.read("#{dir}/specifications/ParseTree-3.0.4.gemspec"))
  @bundled_specs["ParseTree"].loaded_from = "#{dir}/specifications/ParseTree-3.0.4.gemspec"
  @bundled_specs["data_objects"] = eval(File.read("#{dir}/specifications/data_objects-0.10.0.gemspec"))
  @bundled_specs["data_objects"].loaded_from = "#{dir}/specifications/data_objects-0.10.0.gemspec"
  @bundled_specs["do_mysql"] = eval(File.read("#{dir}/specifications/do_mysql-0.10.0.gemspec"))
  @bundled_specs["do_mysql"].loaded_from = "#{dir}/specifications/do_mysql-0.10.0.gemspec"
  @bundled_specs["do_sqlite3"] = eval(File.read("#{dir}/specifications/do_sqlite3-0.10.0.gemspec"))
  @bundled_specs["do_sqlite3"].loaded_from = "#{dir}/specifications/do_sqlite3-0.10.0.gemspec"
  @bundled_specs["merb-pre"] = eval(File.read("#{dir}/specifications/merb-pre-1.1.0.0.gemspec"))
  @bundled_specs["merb-pre"].loaded_from = "#{dir}/specifications/merb-pre-1.1.0.0.gemspec"
  @bundled_specs["rufus-scheduler"] = eval(File.read("#{dir}/specifications/rufus-scheduler-2.0.3.gemspec"))
  @bundled_specs["rufus-scheduler"].loaded_from = "#{dir}/specifications/rufus-scheduler-2.0.3.gemspec"
  @bundled_specs["activesupport"] = eval(File.read("#{dir}/specifications/activesupport-2.3.5.gemspec"))
  @bundled_specs["activesupport"].loaded_from = "#{dir}/specifications/activesupport-2.3.5.gemspec"
  @bundled_specs["feedzirra"] = eval(File.read("#{dir}/specifications/feedzirra-0.0.20.gemspec"))
  @bundled_specs["feedzirra"].loaded_from = "#{dir}/specifications/feedzirra-0.0.20.gemspec"

  def self.add_specs_to_loaded_specs
    Gem.loaded_specs.merge! @bundled_specs
  end

  def self.add_specs_to_index
    @bundled_specs.each do |name, spec|
      Gem.source_index.add_spec spec
    end
  end

  add_specs_to_loaded_specs
  add_specs_to_index

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

module Gem
  @loaded_stacks = Hash.new { |h,k| h[k] = [] }

  def source_index.refresh!
    super
    Bundler.add_specs_to_index
  end
end
