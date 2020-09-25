#!/bin/bash

GEM_VERSION='0.8.1'

rm -rf nxgreport-$GEM_VERSION.gem
sudo gem uninstall nxgreport
gem build nxgreport.gemspec
sudo gem install nxgreport-$GEM_VERSION.gem