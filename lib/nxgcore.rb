require 'fileutils'
require 'pry'
require 'json'
require 'nxgcss.rb'

class NxgCore
    class NxgReport

        include NxgCss

        def initialize(data_provider)
          @data_provider = data_provider
          @data_provider[:pass] = 0
          @data_provider[:fail] = 0
          @data_provider[:total] = 0
        end

        def setup(location: "./NxgReport.html", title: "Features Summary")
            @data_provider[:report_path] = location.empty? ? "./NxgReport.html" : location
            folder_check()
            @data_provider[:title] = title
            @data_provider[:title_color] = ""
            @data_provider[:open_on_completion] = false
            @data_provider[:features] = Array.new()
            @start_time = Time.now.to_f
        end
    
        def open_upon_execution(value: true)
          return if !value

          @data_provider[:open_on_completion] = value
        end
    
        def set_environment(name: "")
          return if name.empty?() 
          
          @data_provider[:environment] = name
        end
    
        def set_app_version(no: "")
          return if no.empty?()
            
          version_no = no.downcase.gsub("app", "").gsub("version", "").strip
          @data_provider[:app_version] = "App Version #{version_no}"
        end
    
        def set_release(name: "")
          return if name.empty?() 
            
          @data_provider[:release_name] = name
        end
    
        def set_os(name: "")
          return if name.empty?() 
            
          @data_provider[:os] = name
        end
    
        def set_device(name: "")
          return if name.empty?() 
            
          @data_provider[:device] = name
        end
    
        def set_execution(date: "")
          return if date.empty?() 
            
          @data_provider[:execution_date] = date
        end
    
        def log_test(feature_name: "", test_name:"", test_status: "", comments: "")
          if feature_name.nil?() || feature_name.strip.empty?()
            log("Feature name cannot be empty.")
            return
          end
  
          if test_status.nil?() || test_status.strip.empty?()
            log("Test status cannot be empty.")
            return
          end

          if test_name.nil?() || test_name.strip.empty?()
            log("Test name cannot be empty.")
            return
          end

          f_name = feature_name.strip
          t_name = test_name.strip
          t_pass = test_status.strip.downcase.include?('pass') ? true : false
          t_comments = comments.strip

          if !feature_exists?(f_name)
            new_feature = {
              "name" => f_name,
              "total" => 0,
              "pass" => 0,
              "fail" => 0,
              "tests" => Array.new()
            }
            @data_provider[:features].push(new_feature)
          end

          update_feature(f_name, t_name, t_pass, t_comments)
          @data_provider[:total] += 1
          @data_provider[t_pass ? :pass : :fail] += 1
        end
    
        def build(execution_time: 0)
          set_execution_time(execution_time)
          write()
          if @data_provider[:open_on_completion]
            system("open #{@data_provider[:report_path]}") if File.file?(@data_provider[:report_path])
          end
        end
    
        # Private methods

        def update_feature(f_name, t_name, t_pass, t_comments)
          @data_provider[:features].each do |feature|
            if feature["name"].eql?(f_name)
              feature["total"]+=1
              feature[t_pass ? "pass" : "fail"]+=1
              feature["tests"].push({
                "name" => t_name,
                "testPass" => t_pass,
                "comments" => t_comments
              })
              return
            end
          end
        end

        def feature_exists?(feature_name)
          @data_provider[:features].each do |feature|
            return true if feature["name"].eql?(feature_name)
          end
          return false
        end

        def log(message)
          puts("🤖- #{message}")
        end
    
        def folder_check()
          folder = File.dirname(@data_provider[:report_path])
          FileUtils.mkdir_p(folder) unless File.directory?(folder)
        end
    
        def clean()
            File.delete(@data_provider[:report_path]) if File.file?(@data_provider[:report_path])
        end
    
        def write()
          clean()
          if @data_provider[:features].length == 0
            log("No tests logged, cannot build empty report.")
            return
          end
          template = File.new(@data_provider[:report_path], 'w')
          template.puts("<html lang=\"en\">
                          #{head()}
                          #{body()}
                          #{javascript()}
                        </html>")
          template.close()
        end

        def head()
          "<head>
            <meta charset=\"UTF-8\" />
            <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />
            <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js\"></script>
            <title>Home | #{@data_provider[:title]}</title>
            #{google_fonts_link()}
            #{icons_link()}
            #{css(@data_provider)}
          </head>"
        end

        def google_fonts_link()
          "<link
            href=\"https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300;0,400;0,600;0,700;0,800;1,300;1,400;1,600;1,700;1,800&display=swap\"
            rel=\"stylesheet\"
          />"
        end

        def icons_link()
          "<link
            href=\"https://fonts.googleapis.com/icon?family=Material+Icons\"
            rel=\"stylesheet\"
          />"
        end

        def body()
          "<body id=\"app\" onload=\"onRefresh()\">
            <div id=\"sidebar\" onclick=\"closeDetails()\">
              <div id=\"sidebar-div\">
                <div id=\"sidebar-title-wrap\">
                  <h1 id=\"sidebar-title\">Title</h1>
                  &nbsp;&nbsp;
                  <i class=\"material-icons\" id=\"sidebar-status\">check_circle</i>
                </div>
              </div>
            </div>
          <div id=\"sidebar-overlay\" onclick=\"closeDetails()\">
            <div id=\"sidebar-overlay-grid\"></div>
          </div>
            <div id=\"body-wrap\">
              #{header()}
              #{config()}
              #{features()}
              #{footer()}
            </div>
          </body>"
        end

        def header()
          "<div id=\"header\">
            <h1 id=\"app-title\">#{@data_provider[:title]}</h1>
            <div id=\"theme-wrap\">
              <button id=\"theme-switch\" onclick=\"switchTheme()\">
                <i class=\"material-icons\" id=\"theme-icon\">brightness_2</i>
              </button>
            </div>
          </div>"
        end

        def features()
          "<div class=\"features-grid\"></div>"
      end

      def features_js_array()
        return @data_provider[:features].to_s.gsub("=>", ":")
      end

        def footer()
          "<div id=\"footer\">
            <p>
              Developed by
              <span>
                <a
                  href=\"https://www.linkedin.com/in/balabharathijayaraman\"
                  rel=\"nofollow\"
                  target=\"_blank\"
                  >Balabharathi Jayaraman</a
                >
              </span>
            </p>
          </div>"
        end

        def javascript()
          "<script>
          var darkTheme = false;
          var displayFailuresOnly = false;
      
          const allFeatures = #{features_js_array};
      
          var dataSource = [];
      
          const STATUS = {
            pass: \"check_circle\",
            fail: \"cancel\",
          };
      
          function onRefresh() {
            switchTheme();
            dataSource = allFeatures;
            setFilter();
          }
      
          function updateView() {
            $(\".banner\").removeClass(\"banner\").addClass(\"features-grid\");
            $(\".features-grid\").empty();
      
            if (dataSource.length === 0) {
              console.log(\"inside\");
              $(\".features-grid\")
                .removeClass(\"features-grid\")
                .addClass(\"banner\")
                .append(
                  `<i class=\"banner-text green-font material-icons\">done_all</i><h1>No Failures</>`
                );
              return;
            }
      
            dataSource.forEach((feature, index) => {
              $(\".features-grid\").append(
                `<div class=\"module dark ${
                  feature.fail > 0 ? \"red-bg\" : \"\"
                }\" onclick=\"showDetails(${index})\"><div class=\"funcname\"><h4>${
                  feature.name
                }</h4></div><div class=\"total\"><h6>Total</h6><h4>${
                  feature.total
                }</h4></div><div class=\"pass green-font\"><h6>Passed</h6><h4>${
                  feature.pass
                }</h4></div><div class=\"fail red-font\"><h6>Failed</h6><h4>${
                  feature.fail
                }</h4></div></div>`
              );
            });
          }
      
          function setFilter() {
            if (displayFailuresOnly) {
              $(\"#filter h5\").text(\"Failed\");
              dataSource = allFeatures.filter((feature) => {
                return feature.fail > 0;
              });
            } else {
              $(\"#filter h5\").text(\"All\");
              dataSource = allFeatures;
            }
            updateView();
            displayFailuresOnly = !displayFailuresOnly;
          }
      
          function filterAllFailed() {
            allFailedTests = [];
      
            failedFeatures = allFeatures.filter((feature) => {
              return feature.fail > 0;
            });
      
            for (index = 0; index < failedFeatures.length; index++) {
              failedFeatures[index].tests.filter((test) => {
                if (!test.testPass) {
                  allFailedTests.push(test);
                }
              });
            }
      
            $(\"#sidebar-overlay\").css(\"visibility\", \"visible\");
            $(\"#sidebar-overlay\").css(\"margin-left\", \"40%\");
            $(\"#sidebar\").css(\"width\", \"40%\");
            $(\"#sidebar-title\").css(\"visibility\", \"visible\");
            $(\"#sidebar-status\").css(\"visibility\", \"visible\");
            /* Update Test Information */
      
            $(\"#sidebar-title\").text(\"Failed Tests\");
            $(\"#sidebar-status\").text(STATUS.fail);
            $(\"#sidebar-overlay-grid\").empty();
            allFailedTests.forEach((test) => {
              $(\"#sidebar-overlay-grid\").append(
                `<div id=\"sidebar-overlay-test-info\" onclick=\"()=>{}\"><i class=\"${
                  test.testPass ? \"green-font\" : \"red-font\"
                } material-icons\" style=\"font-size: 1em\">${
                  STATUS.fail
                }</i>&nbsp;&nbsp;<h4 id=\"test-title\">${test.name}</h4>${
                  test.comments !== \"\"
                    ? `<p id=\"error-message\">${test.comments}</p>`
                    : \"\"
                }</div>`
              );
            });
          }
      
          function switchTheme() {
            $(document.documentElement).attr(\"theme\", !darkTheme ? \"light\" : \"dark\");
            $(\"#theme-icon\").text(!darkTheme ? \"wb_sunny\" : \"brightness_2\");
            darkTheme = !darkTheme;
          }
      
          function closeDetails() {
            $(\"#sidebar-title\").css(\"visibility\", \"hidden\");
            $(\"#sidebar-status\").css(\"visibility\", \"hidden\");
            $(\"#sidebar-overlay\").css(\"visibility\", \"hidden\");
            $(\"#sidebar-overlay\").css(\"margin-left\", \"0\");
            $(\"#sidebar\").css(\"width\", \"0\");
          }
      
          window
            .matchMedia(\"(prefers-color-scheme: dark)\")
            .addEventListener(\"change\", (e) => {
              darkTheme = e.matches;
              switchTheme();
            });
      
          function showDetails(featureID) {
            feature = dataSource[featureID];
      
            $(\"#sidebar-overlay\").css(\"visibility\", \"visible\");
            $(\"#sidebar-overlay\").css(\"margin-left\", \"40%\");
            $(\"#sidebar\").css(\"width\", \"40%\");
            $(\"#sidebar-title\").css(\"visibility\", \"visible\");
            $(\"#sidebar-status\").css(\"visibility\", \"visible\");
            /* Update Test Information */
      
            $(\"#sidebar-title\").text(feature.name);
            $(\"#sidebar-overlay-grid\").empty();
            feature.tests.forEach((test) => {
              $(\"#sidebar-overlay-grid\").append(
                `<div id=\"sidebar-overlay-test-info\" onclick=\"()=>{}\"><i class=\"${
                  test.testPass ? \"green-font\" : \"red-font\"
                } material-icons\" style=\"font-size: 1em\">${
                  test.testPass ? STATUS.pass : STATUS.fail
                }</i>&nbsp;&nbsp;<h4 id=\"test-title\">${test.name}</h4>${
                  test.comments !== \"\"
                    ? `<p id=\"error-message\">${test.comments}</p>`
                    : \"\"
                }</div>`
              );
            });
      
            for (index = 0; index < feature.tests.length; index++) {
              if (!feature.tests[index].testPass) {
                $(\"#sidebar-status\").text(STATUS.fail);
                return;
              }
            }
            $(\"#sidebar-status\").text(STATUS.pass);
          }
      
          </script>"
        end
    
        def config()
          return if @data_provider.length == 0

          return "<div class=\"params-container\">
                  #{release_name()}
                  #{execution_date()}
                  #{device()}
                  #{os()}
                  #{app_version()}
                  #{environment()}
                  #{passed_tests()}
                  #{failed_tests()}
                  #{percentage_pass()}
                  #{execution_time()}
                  #{filter()}
                </div>"
        end

        def execution_time()
          return if !@data_provider.key?(:environment)
          
          return config_item("Total execution time", @data_provider[:execution_time],'access_time')
        end

        def filter()
          "<div class=\"param-wrap\" onclick=\"setFilter()\" id=\"filter\" title=\"Filter tests\">
            <i class=\"pi material-icons\">filter_list</i>
            <h5 id=\"pt\">Failed</h5>
          </div>"
        end

        def passed_tests()
          "<div class=\"param-wrap\" title=\"Passed tests\">
            <i class=\"pi green-font material-icons\">check_circle</i>
            <h5 id=\"pt\">#{@data_provider[:pass] == 0 ? "None" : @data_provider[:pass]}</h5>
          </div>"
        end

        def failed_tests()
          "<div class=\"param-wrap\" title=\"Failed tests\" #{@data_provider[:fail] > 0 ? "onclick=\"filterAllFailed()\" style=\"cursor: pointer\"" : ""}>
            <i class=\"pi red-font material-icons\">cancel</i>
            <h5 id=\"pt\">#{@data_provider[:fail] == 0 ? "None" : @data_provider[:fail]}</h5>
          </div>"
        end

        def percentage_pass()
          pass_percentage = ((@data_provider[:pass]/@data_provider[:total].to_f) * 100).round(2)

          return config_item("Pass percentage", pass_percentage,'equalizer')
        end
    
        def environment()
          return if !@data_provider.key?(:environment)

          return config_item("Test environment", @data_provider[:environment], "layers")
        end
    
        def app_version()
          return if !@data_provider.key?(:app_version)

          return config_item("App version tested", @data_provider[:app_version], "info")
        end
    
        def release_name()
          return if !@data_provider.key?(:release_name)

          return config_item("Release", @data_provider[:release_name], "bookmark")
        end
    
        def os()
          return if !@data_provider.key?(:os)

          return config_item("Os tested", @data_provider[:os], "settings")
        end
    
        def device()
          return if !@data_provider.key?(:device)
            
          return config_item("Device tested", @data_provider[:device], "devices")
        end
    
        def execution_date()
          @data_provider[:execution_date] = Time.now().strftime("%b %d, %Y") if !@data_provider.key?(:execution_date)
            
          return config_item("Execution date", @data_provider[:execution_date], "event")
        end

        def config_item(toot_tip, name, icon)
          "<div class=\"param-wrap\" title=\"#{toot_tip}\">
            <i class=\"pi material-icons\">#{icon}</i>
            <h5 id=\"pt\">#{name}</h5>
          </div>"
        end

        def set_execution_time(time)
          time_diff_in_mins = 0
          if time == 0
            @end_time = Time.now.to_f
            time_diff_in_mins = ((@end_time - @start_time)  / 60).to_i
          else
            time_diff_in_mins = (time / 60).to_i
          end

          if time_diff_in_mins >= 60
            time_diff_in_hrs = (time_diff_in_mins / 60.to_f).round(2)
            @data_provider[:execution_time] = "#{time_diff_in_hrs} #{time_diff_in_hrs == 1 ? "hour" : "hours"}"
          else
            @data_provider[:execution_time] = "#{time_diff_in_mins} mins"
          end
        end
    
        private :log, :clean, :write
        private :execution_date, :device, :os, :release_name, :app_version, :environment
        private :features, :config, :config_item, :features_js_array
        private :head, :body, :header, :footer, :javascript
    end

    private_constant :NxgReport

    def instance(data_provider: Hash.new())
        NxgReport.new(data_provider)
    end
end