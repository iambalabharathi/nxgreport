# **Next Gen Report 💎** [![Gem Version](https://badge.fury.io/rb/nxgreport.svg)](https://badge.fury.io/rb/nxgreport)

A simple light weighted gem to generate a beautiful emailable test report.

## **Installation**

    gem install nxgreport

## **Usage**

    require 'nxgreport'

    $NxgReport.setup(location: "Absolute file path", title: "My Report")
    $NxgReport.log_test(feature_name:"Feature Name", test_status:"Pass/Fail")
    $NxgReport.build()

## **Cucumber Ruby Usage**

In **env.rb** add the below line

    $NxgReport.setup(location: "Absolute file path", title: "My Report")

In **hooks.rb** add the below block of code.

    After do |scenario|
        feature_name = scenario.feature.name
        scenario_pass = !scenario.is_failed?() ? "Pass" : "Fail"
        $NxgReport.log_test(feature_name:feature_name, test_status:scenario_pass)
    end

    at_exit do
        $NxgReport.build()
    end

## **Report Look**

![Light Mode](./demo/light.png)

![Dark Mode](./demo/dark.png)
