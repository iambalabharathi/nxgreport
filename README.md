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

<div style="text-align:center;"><img src="./demo/light.png" alt="Light Mode" width="800"/></div>

<div style="text-align:center;"><img src="./demo/dark.png" alt="Dark Mode" width="800"/></div>
