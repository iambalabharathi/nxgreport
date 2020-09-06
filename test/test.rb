require "test/unit"
require "./lib/nxgreport.rb"

class TestNxgReport < Test::Unit::TestCase
    
    def test_default_location()
        nxg_report = NxgReport.new()
        nxg_report.setup()
        assert_equal("./NxgReport.html", nxg_report.report_location())
    end

end

class TestNxgReportGeneration < Test::Unit::TestCase

    def test_report_did_not_generate_when_no_tests_logged()
        nxg_report = NxgReport.new()
        nxg_report.setup()
        report_location = nxg_report.report_location()
        nxg_report.build()
        assert(!File.file?(report_location))
    end

    def test_report_is_created_when_one_test_is_logged()
        nxg_report = NxgReport.new()
        nxg_report.setup()
        report_location = nxg_report.report_location()
        nxg_report.log_test("Feature One", "Pass")
        nxg_report.build()
        assert(File.file?(report_location))
    end

end