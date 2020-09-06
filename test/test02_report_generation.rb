require "test/unit"
require "./lib/nxgreport.rb"

class TestNxgReportGeneration < Test::Unit::TestCase

    def setup()
        @default_report_location = "./NxgReport.html"
        File.delete(@default_report_location) if File.file?(@default_report_location)
        @nxg_report = NxgReport.new()
    end

    def test_report_did_not_generate_when_no_tests_logged()
        @nxg_report.setup()
        report_location = @nxg_report.nxg_report_path()
        
        @nxg_report.build()
        
        assert(!File.file?(report_location))
    end

    def test_feature_not_added_if_name_is_empty() 
        @nxg_report.setup()
        @nxg_report.log_test("", "Pass")

        assert_equal(0, @nxg_report.features.length)
    end

    def test_feature_count()
        @nxg_report.setup()
        @nxg_report.log_test("Login", "Pass")
        @nxg_report.log_test("Login", "Pass")
        @nxg_report.log_test("New Login", "Pass")

        assert_equal(2, @nxg_report.features.length)
    end

    def test_totalpassfail_per_feature()
        @nxg_report.setup()
        @nxg_report.log_test("Login", "Pass")
        @nxg_report.log_test("Login", "Pass")
        @nxg_report.log_test("SignUp", "Pass")
        @nxg_report.log_test("Login", "Fail")
        @nxg_report.log_test("SignUp", "Pass")
        @nxg_report.log_test("Login", "Pass")

        assert_equal(4, @nxg_report.features["Login"][0])
        assert_equal(3, @nxg_report.features["Login"][1])
        assert_equal(1, @nxg_report.features["Login"][2])
    end

    def test_report_is_created_when_one_test_is_logged()
        @nxg_report.setup()
        report_location = @nxg_report.nxg_report_path()        
        @nxg_report.log_test("Login", "Pass")
        
        @nxg_report.build()
       
        assert(File.file?(report_location))
    end

end