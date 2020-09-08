require "test/unit"
require "./lib/nxgreport.rb"

class TestNxgReportGeneration < Test::Unit::TestCase

    def setup()
        @default_report_location = "./NxgReport.html"
        @nxg_report = NxgReport.new()
    end

    def test_report_created_successfully_when_there_is_1_tests_logged()
        @nxg_report.setup()
        @nxg_report.log_test(feature_name:"Login", test_status:"Pass")
        @nxg_report.build()
       
        assert(File.file?(@default_report_location))
    end

    def test_report_is_not_created_if_0_tests_logged()
        @nxg_report.setup()
        @nxg_report.build()
       
        assert(!File.file?(@default_report_location))
    end

end