# **Next Gen Report 💎** [![Gem Version](https://badge.fury.io/rb/nxgreport.svg)](https://badge.fury.io/rb/nxgreport)

A simple light weighted gem to generate a beautiful emailable test report.

It displays a single view where tests (total, pass, fail) are grouped by functionality. The result is a single static HTML file with an option to switch between dark & light modes.

## **Installation**

    gem install nxgreport

## **Usage**

```
require 'nxgreport'

$NxgReport.setup(location: "Absolute file path", title: "My Report")
$NxgReport.log_test(feature_name:"Feature Name", test_status:"Pass/Fail")
$NxgReport.build()
```

## **Cucumber Ruby Usage**

In **env.rb** add the below line

```
$NxgReport.setup(location: "Absolute file path", title: "My Report")
```

In **hooks.rb** add the below block of code.

```
After do |scenario|
    feature_name = scenario.feature.name
    scenario_pass = !scenario.is_failed?() ? "Pass" : "Fail"
    $NxgReport.log_test(feature_name:feature_name, test_status:scenario_pass)
end

at_exit do
    $NxgReport.build()
end
```

## **Report Look**

![Light Mode](./demo/light.png)

![Dark Mode](./demo/dark.png)

## **Parameters Explaination**

```
$NxgReport.setup(location, title)
```

- **location (optional):** _This is an absolute path where the report should be generated (ex: "C:\Report\index.hmtl). If not passed, the report will be generated in the **root folder** as **NxgReport.html**_
- **title (optional):** _This is title of report displayed. If not passed, the report will be generated with a title "Features Summary"_

```
$NxgReport.log_test(feature_name:"Feature Name", test_status:"Pass/Fail")
```

- **feature_name:** _This is the feature name under the test should be logged ex:(Login with Biometrics)_
- **test_status:** _This is the status of the test, allowed values are Pass or Fail_
