<h1 align="center">
    <a href="https://github.com/balabharathijayaraman/nxgreport">
        <img src="./docs/Nxg.gif" alt="Markdownify" width="200">
    </a>
    <br> Next Gen Report 💎 <br>
</h1>

<p align="center">
    <a href="https://github.com/iambalabharathi/nxgreport/actions/workflows/ci-build-test-publish.yml">
        <img src="https://github.com/iambalabharathi/nxgreport/actions/workflows/ci-build-test-publish.yml/badge.svg?branch=main" alt="Pipeline Status" height="18">
    </a>
    &nbsp;&nbsp;
    <a href="#">
        <img alt="GitHub" src="https://img.shields.io/github/license/balabharathijayaraman/nxgreport?color=blue" height="18">
    </a>
    &nbsp;&nbsp;
    <a href="#">
        <img alt="Ruby Version" src="https://img.shields.io/badge/ruby version-2.3.0-red" height="18">
    </a>
    &nbsp;&nbsp;
    <a href="https://badge.fury.io/rb/nxgreport">
        <img src="https://badge.fury.io/rb/nxgreport.svg" alt="Gem Version" height="18">
    </a>
</p>

<h4 align="center">
    Stunning test report in 5 mins 🚀 
    </br>
    </br>
    A simple light weighted gem to generate a beautiful e-mailable test report. (3500+ Downloads)</h4>
<p align="center">
    It displays a single view where tests (total, pass, fail) are grouped by functionality. The result is a single static HTML file with an option to switch between dark & light modes.
</p>

<p align="center">
  <a href="#demo">Demo</a> •
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#license">License</a>
</p>

## **Demo**

<div align="center">
    <img src="./docs/light-summary.png" alt="Markdownify" width="800">
    <br/>
    <img src="./docs/dark-summary.png" alt="Markdownify" width="800">
</div>

## **Installation**

    gem install nxgreport

## **Usage**

```ruby
require 'nxgreport'

$NxgReport.setup(location: "Absolute file path", title: "My Report")

$NxgReport.set_device(name: "iPhone X")
$NxgReport.set_os(name: "iOS 12.1")
$NxgReport.set_release(name: "M09 2020")
$NxgReport.set_app_version(no: "app0.9.1")
$NxgReport.set_environment(name: "QA")

$NxgReport.log_test(
        feature_name: "Feature Name",
        test_name: "This is a test",
        test_status: "Pass/Fail",
        comments: "Error message or additional comments about the test",
        tag: "critical")

$NxgReport.build()
```

## **Cucumber Ruby Usage**

In `env.rb` add the below line

```ruby
require 'nxgreport'

$NxgReport.setup(location: "Absolute file path", title: "My Report")

$NxgReport.set_device(name: "iPhone X")
$NxgReport.set_os(name: "iOS 12.1")
$NxgReport.set_release(name: "M09 2020")
$NxgReport.set_app_version(no: "app0.9.1")
$NxgReport.set_environment(name: "QA")
```

In `hooks.rb` add the below block of code.

```ruby
After do |scenario|

    feature_name = scenario.feature.name
    scenario_status = !scenario.failed?() ? "Pass" : "Fail"
    comments = (scenario.exception.nil?) ? "Success" : scenario.exception.message

    $NxgReport.log_test(
            feature_name: feature_name,
            test_name: scenario.name,
            test_status: scenario_status,
            comments: comments,
            tag: "critical")
end

at_exit do
    $NxgReport.build()
end
```

## **Parameters Explaination**

```ruby
$NxgReport.setup(location, title)
```

- `location (optional):` - _File path - C:\Report\index.hmtl_
- `title (optional):` - _String_

```ruby
$NxgReport.log_test(
        feature_name: "Login",
        test_name: "Login with email address and password",
        test_status: "Pass",
        comments: "System failure",
        tag: "Critical")
```

- `feature_name` - _String_
- `test_name` - _String_
- `test_status` - _Pass or Fail_
- `comments (optional)` - _Sring_
- `tag (optional)` - _Sring_

## **Like it?**

<a href="https://www.buymeacoffee.com/iambalabharathi" target="_blank"><img src="https://bmc-cdn.nyc3.digitaloceanspaces.com/BMC-button-images/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>

## **Contributing**

I'm open to any contribution. It has to be tested properly though.

## **License**

Copyright © 2020 [MIT License](LICENSE)
