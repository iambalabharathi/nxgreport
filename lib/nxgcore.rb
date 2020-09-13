require 'fileutils'

require 'nxgcss.rb'

class NxgCore
    class NxgReport

        include NxgCss

        def initialize(data_provider)
          @data_provider = data_provider
        end

        def setup(location: "./NxgReport.html", title: "Features Summary")
            @data_provider[:report_path] = location.empty? ? "./NxgReport.html" : location
            folder_check()
            @data_provider[:title] = title
            @data_provider[:title_color] = "background: linear-gradient(to bottom right, #ff644e, #cb3018);"
            @data_provider[:open_on_completion] = false
            @data_provider[:features] = Hash.new()
        end

        def set_title_color(hex_color: "")
          if hex_color.strip().empty?() || hex_color.strip()[0] != "#"
            log("set_title_color method is called with empty color. please check the code.")
            return
          end
          @data_provider[:title_color] = "background-color: #{hex_color.strip().downcase()};"
        end
    
        def open_upon_execution(value: true)
          if !value
            return
          end
          @data_provider[:open_on_completion] = value
        end
    
        def set_environment(name: "")
          if name.empty?() 
            return
          end
          @data_provider[:environment] = name
        end
    
        def set_app_version(no: "")
          if no.empty?()
            return
          end
          version_no = no.downcase.gsub("app", "").gsub("version", "").strip
          @data_provider[:app_version] = "App Version #{version_no}"
        end
    
        def set_release(name: "")
          if name.empty?() 
            return
          end
          @data_provider[:release_name] = name
        end
    
        def set_os(name: "")
          if name.empty?() 
            return
          end
          @data_provider[:os] = name
        end
    
        def set_device(name: "")
          if name.empty?() 
            return
          end
          @data_provider[:device] = name
        end
    
        def set_execution(date: "")
          if date.empty?() 
            return
          end
          @data_provider[:execution_date] = date
        end
    
        def log_test(feature_name: "", test_status: "")
          if feature_name.nil?() || feature_name.strip.empty?()
            log("Feature name cannot be empty.")
            return
          end
  
          if test_status.nil?() || test_status.strip.empty?()
            log("Test status cannot be empty.")
            return
          end
          
          test_pass = test_status.downcase.include?('pass')
          name = feature_name.strip()
  
          if !@data_provider[:features].key?(name)
            @data_provider[:features][name]=[0,0,0]
          end

          @data_provider[:features][name][0]+=1
          @data_provider[:features][name][(test_pass) ? 1 : 2]+=1
        end
    
        def build()
          write()
          if @data_provider[:open_on_completion]
              if File.file?(@data_provider[:report_path])
                system("open #{@data_provider[:report_path]}")
              end
          end
        end
    
        # Private methods
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
          "<body class=\"dark\" id=\"app\">
            <div class=\"body-wrapper\">
              #{header()}
              #{config()}
              #{features()}
              #{footer()}
            </div>
          </body>"
        end

        def header()
          "<div class=\"header\">
            <h1>#{@data_provider[:title]}</h1>
            <div class=\"button-wrapper\">
              <button id=\"theme-switch\" onclick=\"handleThemeSwitch()\">
                <i class=\"material-icons\" id=\"theme-switch-icon\">brightness_2</i>
              </button>
            </div>
          </div>"
        end

        def features()
          "<div class=\"mc\"></div>"
      end

      def features_js_array()
        js_array = ''
        @data_provider[:features].each do |name, metrics|
          js_array += "{ name: \"#{name}\", total: #{metrics[0]}, pass: #{metrics[1]}, fail: #{metrics[2]} },"
        end
        return js_array
      end

        def footer()
          "<div class=\"footer\">
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
              var theme = \"dark\";
              var displayAllTests = true;
              
              var features = [
                  #{features_js_array()}
              ]
          
              window.onload = (e) => {
                displayAll()
              };
          
              function handleThemeSwitch() {
                if (theme === \"dark\") {
                  theme = \"light\";
                  document.getElementById(\"app\").classList.remove(\"dark\");
                  document.getElementById(\"theme-switch-icon\").innerHTML = \"wb_sunny\";
                  document.getElementById(\"theme-switch-icon\");
                  return;
                }
                if (theme === \"light\") {
                  theme = \"dark\";
                  document.getElementById(\"app\").classList.add(\"dark\");
                  document.getElementById(\"theme-switch-icon\").innerHTML = \"brightness_2\";
                }
              }
          
              function handleFilter() {
                displayAllTests = !displayAllTests;
                if (displayAllTests) {
                  displayAll();
                } else {
                  displayFailuresOnly();
                }
              }
          
              function displayAll() {
                $(\"#filter h5\").text(\"All\");
                mcNode = document.getElementsByClassName(\"mc\");
                $(\".mc\").empty();
                features.forEach((item) => {
                  $(\".mc\").append(
                    `<div class=\"module dark ${
                      item.fail > 0 ? \"danger\" : \"\"
                    }\"><div class=\"funcname\"><h4>${
                      item.name
                    }</h4></div><div class=\"total\"><h6>Total</h6><h4>${
                      item.total
                    }</h4></div><div class=\"pass\"><h6>Passed</h6><h4>${
                      item.pass
                    }</h4></div><div class=\"fail\"><h6>Failed</h6><h4>${
                      item.fail
                    }</h4></div></div>`
                  );
                });
              }

              function displayFailuresOnly() {
                $(\"#filter h5\").text(\"Failures\");
                mcNode = document.getElementsByClassName(\"mc\");
                $(\".mc\").empty();
                features.forEach((item) => {
                  if (item.fail > 0) {
                    $(\".mc\").append(
                      `<div class=\"module dark danger\"><div class=\"funcname\"><h4>${item.name}</h4></div><div class=\"total\"><h6>Total</h6><h4>${item.total}</h4></div><div class=\"pass\"><h6>Passed</h6><h4>${item.pass}</h4></div><div class=\"fail\"><h6>Failed</h6><h4>${item.fail}</h4></div></div>`
                    );
                  }
                });
              }
            </script>"
        end
    
        def config()
          if @data_provider.length == 0
            return
          end
    
          return "<div class=\"configuration-container\">
                  #{release_name()}
                  #{execution_date()}
                  #{device()}
                  #{os()}
                  #{app_version()}
                  #{environment()}
                  <div class=\"configuration-wrapper\" onclick=\"handleFilter()\" id=\"filter\">
                    <i class=\"configuration-icon material-icons\">filter_list</i>
                    <h5 id=\"configuration-text\">Failed</h5>
                  </div>
                </div>"
        end
    
        def environment()
          if !@data_provider.key?(:environment)
            return
          end

          return config_item(@data_provider[:environment], "layers")
        end
    
        def app_version()
          if !@data_provider.key?(:app_version)
            return
          end

          return config_item(@data_provider[:app_version], "info")
        end
    
        def release_name()
          if !@data_provider.key?(:release_name)
            return
          end

          return config_item(@data_provider[:release_name], "bookmark")
        end
    
        def os()
          if !@data_provider.key?(:os)
            return
          end

          return config_item(@data_provider[:os], "settings")
        end
    
        def device()
          if !@data_provider.key?(:device)
            return
          end

          return config_item(@data_provider[:device], "devices_other")
        end
    
        def execution_date()
          if !@data_provider.key?(:execution_date)
            return
          end

          return config_item(@data_provider[:execution_date], "date_range")
        end

        def config_item(name, icon)
          "<div class=\"configuration-wrapper\">
            <i class=\"configuration-icon material-icons\">#{icon}</i>
            <h5 id=\"configuration-text\">#{name}</h5>
          </div>"
        end
    
        private :log, :clean, :write
        private :execution_date, :device, :os, :release_name, :app_version, :environment
        private :features, :config, :config_item, :features_js_array
        private :head, :body, :header, :footer, :javascript
    end

    private_constant :NxgReport

    def instance(data_provider: Hash.new())
        return NxgReport.new(data_provider)
    end
end