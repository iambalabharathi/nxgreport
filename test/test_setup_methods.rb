require "test/unit"
require "./lib/nxgreport.rb"

class TestNxgReport < Test::Unit::TestCase
    
    def setup()
        @expected_default_report_location = "./NxgReport.html"
        File.delete(@expected_default_report_location) if File.file?(@expected_default_report_location)
        @nxg_report = NxgReport.new()
    end

    def test_nxg_report_global_variable_is_not_nil()
        assert_not_nil($NxgReport)
    end

    def test_default_location()
        @nxg_report.setup()
        assert_equal(@expected_default_report_location, @nxg_report.report_location())
    end

end