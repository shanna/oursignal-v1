#!/usr/bin/env ruby
require 'simple_statistics'
require './lib/oursignal'
require 'math/ema'

sample = [0.1]

ema1 = Math::Ema.new((2.0 / (1 + 1)), 0.1)
puts ema1.update([])

