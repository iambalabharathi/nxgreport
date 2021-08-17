require 'nxgreport/nxgcss.rb'
require 'nxgreport/nxgjs.rb'

module NxgHTML
    
    include NxgCss
    include NxgJavascript

    def html(data_provider)
        @data_provider = data_provider
        "<html lang=\"en\">
            #{head()}
            #{body()}
            #{js(@data_provider)}
        </html>"
    end

    def head()
        "<head>
          <meta charset=\"UTF-8\" />
          <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />
          <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js\"></script>
          <script> #{js_detect_system_dark_mode()}</script>
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
          <div id=\"sidebar\" onclick=\"closeDetails(event)\">
            <div id=\"sidebar-div\">
              <div id=\"sidebar-title-wrap\">
                <h1 id=\"sidebar-title\">Title</h1>
                <i class=\"material-icons\" id=\"sidebar-status\">check_circle</i>
              </div>
              <div id=\"sidebar-catergories\">
              </div>
            </div>
          </div>
        <div id=\"sidebar-overlay\" onclick=\"closeDetails(event)\">
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
              <i class=\"material-icons\" id=\"theme-icon\">wb_sunny</i>
            </button>
          </div>
        </div>"
    end

    def features()
        "<div class=\"features-grid\"></div>"
    end

    def footer()
        "<div id=\"footer\">
          <p>
            Developed by
            <span>
              <a
                href=\"https://www.linkedin.com/in/balabharathijayaraman\"
                rel=\"noopener\"
                target=\"_blank\"
                >Balabharathi Jayaraman</a
              >
            </span>
          </p>
        </div>"
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

        return "<div class=\"param-wrap\" title=\"Pass percentage\">
                  <i class=\"pi #{pass_percentage.to_i == 100 ? "green-font" : ""} material-icons\">equalizer</i>
                  <h5 id=\"pt\">#{pass_percentage.to_i == 100 ? pass_percentage.to_i : pass_percentage}%</h5>
                </div>"
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
end