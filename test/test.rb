require "test/unit"
require "./lib/nxgreport.rb"

class TestNxgReport < Test::Unit::TestCase
    def test_default_location
      $NxgReport.setup()
      assert_equal("./NxgReport.html", $NxgReport.report_location())
    end
end