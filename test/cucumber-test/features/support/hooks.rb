

After do | scenario |
    $NxgReport.log_test("Demo Scenario", "Pass")
end

at_exit do
    $NxgReport.build()
end