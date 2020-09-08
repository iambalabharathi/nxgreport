require "test/unit"
require "./lib/nxgreport.rb"

class TestNxgReportGeneration < Test::Unit::TestCase

    def setup()
        @default_report_location = "./NxgReport.html"
        @nxg_report = NxgReport.new()
    end

    def test_report_is_created_when_one_test_is_logged()
        @nxg_report.setup()
        @nxg_report.log_test(feature_name:"Login", test_status:"Pass")
        @nxg_report.build()
       
        assert(File.file?(@default_report_location))
    end

end