#!/bin/bash

GEM_VERSION='0.8.0'

gem build nxgreport.gemspec
sudo gem install nxgreport-$GEM_VERSION.gem
gem push nxgreport-$GEM_VERSION.gem