require 'fileutils'
require "nxgreport/version"
require 'nxgreport/nxgcore.rb'

$NxgReport = NxgCore.new().instance()
puts("Initialized NxgReport instance [✓]")
