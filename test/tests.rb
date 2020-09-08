require "test/unit"
require "./lib/nxgreport.rb"

class TestNxgReportGeneration < Test::Unit::TestCase

    def setup()
        @stub_data_provider = Hash.new()
        @nxg_report = NxgCore.new().instance(data_provider: @stub_data_provider)
    end

    def test_default_folder_path()
        @nxg_report.setup()
        assert_equal("./NxgReport.html", @stub_data_provider[:report_path])
    end

    def test_folder_path_change()
        @nxg_report.setup(location: "./NewLocation/index.html")

        assert_equal("./NewLocation/index.html", @stub_data_provider[:report_path])
    end

    def test_default_report_title()
        @nxg_report.setup()

        assert_equal("Features Summary", @stub_data_provider[:title])
    end

    def test_title_change()
        @nxg_report.setup(title: "New Title")

        assert_equal("New Title", @stub_data_provider[:title])
    end

    def test_default_title_color()
        @nxg_report.setup()

        assert_equal("background: linear-gradient(to bottom right, #ff644e, #cb3018);", @stub_data_provider[:title_color])
    end

    def test_title_color_change()
        @nxg_report.setup()

        @nxg_report.set_title_color(hex_color: "#123123")
        assert_equal("background-color: #123123;", @stub_data_provider[:title_color])
    end

    def test_default_open_on_completion_setting()
        @nxg_report.setup()

        assert(!@stub_data_provider[:open_on_completion])
    end

    def test_open_on_completion_setting_change_to_true()
        @nxg_report.setup()

        @nxg_report.open_upon_execution(value: true)

        assert(@stub_data_provider[:open_on_completion])
    end

    def test_open_on_completion_setting_change_to_false()
        @nxg_report.setup()

        @nxg_report.open_upon_execution(value: false)

        assert(!@stub_data_provider[:open_on_completion])
    end

    def test_environment_is_not_set_by_default()
        @nxg_report.setup()

        assert(!@stub_data_provider.key?(:environment))
    end

    def test_environment_is_not_set_if_no_argument_is_passed()
        @nxg_report.setup()
        @nxg_report.set_envrionment()

        assert(!@stub_data_provider.key?(:environment))
    end

    def test_environment_setting_change()
        @nxg_report.setup()

        @nxg_report.set_envrionment(name: "QA")

        assert(@stub_data_provider.key?(:environment))
        assert_equal("QA", @stub_data_provider[:environment])
    end

    def test_app_version_is_not_set_by_default()
        @nxg_report.setup()

        assert(!@stub_data_provider.key?(:app_version))
    end

    def test_app_version_is_not_set_if_no_argument_is_passed()
        @nxg_report.setup()
        @nxg_report.set_app_version()

        assert(!@stub_data_provider.key?(:app_version))
    end

    def test_app_version_setting_change_alphanumeric()
        @nxg_report.setup()

        @nxg_report.set_app_version(no: "V0.1")

        assert(@stub_data_provider.key?(:app_version))
        assert_equal("App Version v0.1", @stub_data_provider[:app_version])
    end

    def test_app_version_setting_change_numeric()
        @nxg_report.setup()

        @nxg_report.set_app_version(no: "0.1")

        assert(@stub_data_provider.key?(:app_version))
        assert_equal("App Version 0.1", @stub_data_provider[:app_version])

        @nxg_report.set_app_version(no: "App 0.1")

        assert(@stub_data_provider.key?(:app_version))
        assert_equal("App Version 0.1", @stub_data_provider[:app_version])

        @nxg_report.set_app_version(no: "App VERSION 0.1")

        assert(@stub_data_provider.key?(:app_version))
        assert_equal("App Version 0.1", @stub_data_provider[:app_version])
    end

    def test_release_is_not_set_by_default()
        @nxg_report.setup()

        assert(!@stub_data_provider.key?(:release_name))
    end

    def test_release_is_not_set_if_no_argument_is_passed()
        @nxg_report.setup()
        @nxg_report.set_envrionment()

        assert(!@stub_data_provider.key?(:release_name))
    end

    def test_release_setting_change()
        @nxg_report.setup()

        @nxg_report.set_release(name: "M09 2020")

        assert(@stub_data_provider.key?(:release_name))
        assert_equal("M09 2020", @stub_data_provider[:release_name])
    end
end