# **Next Gen Report** [![Gem Version](https://badge.fury.io/rb/nxgreport.svg)](https://badge.fury.io/rb/nxgreport)

A simple light weighted gem to generate a beautiful emailable test report.

## **Installation**

    gem install nxgreport

## **Usage**

    require 'nxgreport'

    $NxgReport.setup(location: "Absolute file path", title: "My Report")
    $NxgReport.log_test(feature_name:"Feature Name", test_status:"Pass/Fail")
    $NxgReport.build()

## **Report Look**

![Light Mode](./demo/light.png)

![Dark Mode](./demo/dark.png)
