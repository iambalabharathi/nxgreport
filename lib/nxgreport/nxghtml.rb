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
        pass_pct = ((@data_provider[:pass]/@data_provider[:total].to_f) * 100).round(1)
        status_emoji = @data_provider[:fail] == 0 ? "&#x2705;" : "&#x1F9EA;"
        "<head>
          <meta charset=\"UTF-8\" />
          <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />
          <link rel=\"icon\" href=\"data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>&#x1F9EA;</text></svg>\" />
          <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js\"></script>
          <script> #{js_detect_system_dark_mode()}</script>
          <title>#{@data_provider[:title]} &#x2014; #{pass_pct}% passing (#{@data_provider[:pass]}/#{@data_provider[:total]})</title>
          #{google_fonts_link()}
          #{icons_link()}
          #{css(@data_provider)}
        </head>"
    end

    def google_fonts_link()
        "<link
          href=\"https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&display=swap\"
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
          <div id=\"backdrop\" onclick=\"closeModal()\"></div>
          <div id=\"modal\">
            <div id=\"modal-header\">
              <div id=\"modal-title-wrap\">
                <span id=\"modal-status-emoji\"></span>
                <h2 id=\"modal-title\"></h2>
              </div>
              <button id=\"modal-close\" onclick=\"closeModal()\">
                <i class=\"material-icons\">close</i>
              </button>
            </div>
            <div id=\"modal-tags\"></div>
            <div id=\"modal-summary\"></div>
            <div id=\"modal-tests\"></div>
          </div>
          #{header()}
          #{meta_bar()}
          #{health_banner()}
          #{stats()}
          #{tag_section()}
          <div id=\"features-header\">
            <h3 class=\"section-title\">&#x1F4E6; Features</h3>
            #{filter()}
          </div>
          #{features()}
          #{footer()}
        </body>"
    end

    def header()
        "<div id=\"header\">
          <div id=\"header-left\">
            <span id=\"header-logo\">&#x1F9EA;</span>
            <div>
              <div id=\"app-title\">#{@data_provider[:title]}</div>
              <div id=\"app-subtitle\">Test Report &#x2022; #{@data_provider[:total]} tests across #{@data_provider[:features].length} features</div>
            </div>
          </div>
          <button id=\"theme-switch\" onclick=\"switchTheme()\">
            <i class=\"material-icons\" id=\"theme-icon\">wb_sunny</i>
          </button>
        </div>"
    end

    def meta_bar()
        chips = []
        chips << meta_chip("&#x1F516;", @data_provider[:release_name]) if @data_provider.key?(:release_name)
        @data_provider[:execution_date] = Time.now().strftime("%b %d, %Y") if !@data_provider.key?(:execution_date)
        chips << meta_chip("&#x1F4C5;", @data_provider[:execution_date])
        chips << meta_chip("&#x1F4F1;", @data_provider[:device]) if @data_provider.key?(:device)
        chips << meta_chip("&#x2699;&#xFE0F;", @data_provider[:os]) if @data_provider.key?(:os)
        chips << meta_chip("&#x2139;&#xFE0F;", @data_provider[:app_version]) if @data_provider.key?(:app_version)
        chips << meta_chip("&#x1F30D;", @data_provider[:environment]) if @data_provider.key?(:environment)
        chips << meta_chip("&#x23F1;&#xFE0F;", @data_provider[:execution_time]) if @data_provider.key?(:execution_time)
        "<div id=\"meta-bar\">#{chips.join}</div>"
    end

    def meta_chip(emoji, text)
        "<div class=\"meta-chip\">
            <span class=\"meta-emoji\">#{emoji}</span>
            <span>#{text}</span>
        </div>"
    end

    def health_banner()
        pass_pct = ((@data_provider[:pass]/@data_provider[:total].to_f) * 100).round(1)
        if @data_provider[:fail] == 0
            emoji = "&#x1F389;"
            title = "All Tests Passing!"
            desc = "Everything looks great &#x2014; #{@data_provider[:total]} tests all green. Ship it! &#x1F680;"
        elsif pass_pct >= 80
            emoji = "&#x1F60A;"
            title = "Almost There!"
            desc = "#{pass_pct}% passing &#x2014; just #{@data_provider[:fail]} test#{@data_provider[:fail] > 1 ? 's' : ''} to fix. You got this! &#x1F4AA;"
        elsif pass_pct >= 50
            emoji = "&#x1F914;"
            title = "Needs Attention"
            desc = "#{pass_pct}% passing &#x2014; #{@data_provider[:fail]} test#{@data_provider[:fail] > 1 ? 's' : ''} failing. Time to investigate &#x1F50D;"
        else
            emoji = "&#x1F6A8;"
            title = "Critical Issues!"
            desc = "Only #{pass_pct}% passing &#x2014; #{@data_provider[:fail]} test#{@data_provider[:fail] > 1 ? 's' : ''} failing. Needs immediate attention &#x26A0;&#xFE0F;"
        end

        "<div id=\"health-banner\">
          <div class=\"health-emoji\">#{emoji}</div>
          <div class=\"health-text\">
            <h3>#{title}</h3>
            <p>#{desc}</p>
          </div>
        </div>"
    end

    def stats()
        pass_percentage = ((@data_provider[:pass]/@data_provider[:total].to_f) * 100).round(1)
        "<div id=\"stats-grid\">
          <div class=\"stat-card\">
            <div class=\"stat-emoji\">&#x1F4CB;</div>
            <div class=\"stat-label\">Total Tests</div>
            <div class=\"stat-value blue\">#{@data_provider[:total]}</div>
          </div>
          <div class=\"stat-card\">
            <div class=\"stat-emoji\">&#x2705;</div>
            <div class=\"stat-label\">Passed</div>
            <div class=\"stat-value green\">#{@data_provider[:pass]}</div>
          </div>
          <div class=\"stat-card\" #{@data_provider[:fail] > 0 ? "onclick=\"filterAllFailed()\" style=\"cursor:pointer\"" : ""}>
            <div class=\"stat-emoji\">&#x274C;</div>
            <div class=\"stat-label\">Failed</div>
            <div class=\"stat-value red\">#{@data_provider[:fail]}</div>
          </div>
          <div class=\"stat-card\">
            <div class=\"stat-emoji\">&#x1F4CA;</div>
            <div class=\"stat-label\">Pass Rate</div>
            <div class=\"stat-value amber\">#{pass_percentage.to_i == 100 ? '100' : pass_percentage}%</div>
          </div>
        </div>"
    end

    def filter()
        "<div onclick=\"setFilter()\" id=\"filter\" title=\"Filter tests\">
            <span class=\"filter-emoji\">&#x1F50D;</span>
            <h5>Failed</h5>
        </div>"
    end

    def tag_section()
        "<div id=\"tag-section\">
          <h3 class=\"section-title\">&#x1F3F7;&#xFE0F; Tags</h3>
          <div id=\"tag-filters\"></div>
          <div id=\"charts-grid\">
            <div id=\"pie-chart-card\">
              <h4 class=\"chart-title\">&#x1F967; Test Results</h4>
              <div id=\"pie-chart-wrap\">
                <svg id=\"pie-chart-svg\" viewBox=\"0 0 240 240\"></svg>
              </div>
              <div id=\"pie-chart-legend\"></div>
            </div>
            <div id=\"tag-chart\">
              <h4 class=\"chart-title\">&#x1F4C8; Tests by Tag</h4>
              <div id=\"tag-chart-legend\">
                <div class=\"legend-item\"><span class=\"legend-dot pass\"></span>&#x2705; Passed</div>
                <div class=\"legend-item\"><span class=\"legend-dot fail\"></span>&#x274C; Failed</div>
              </div>
              <svg id=\"line-chart-svg\" preserveAspectRatio=\"xMidYMid meet\"></svg>
            </div>
          </div>
        </div>"
    end

    def features()
        "<div class=\"features-grid\"></div>"
    end

    def footer()
        "<div id=\"footer\">
          <p>
            &#x1F680; Made with &#10084;&#65039; by
            <a href=\"https://www.linkedin.com/in/iambalabharathi\" rel=\"noopener\" target=\"_blank\">Balabharathi Jayaraman</a>
            &#x2728;
          </p>
        </div>"
    end

    def config()
        return if @data_provider.length == 0
        return ""
    end

    def execution_time()
        return if !@data_provider.key?(:environment)
        return config_item("Total execution time", @data_provider[:execution_time],'access_time')
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
