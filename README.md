# **Next Gen Report**

A simple light weighted gem to beautify your test reports.

## **Installation**

    gem install nxgreport

## **Usage**

    require 'nxgreport'

    $NxgReport.setup(location: "Absolute file path")
    $NxgReport.log_test(feature_name:"Feature Name", test_status:"Pass/Fail")
    $NxgReport.build()
