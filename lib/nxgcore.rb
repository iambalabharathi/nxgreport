require 'fileutils'

class NxgCore
    class NxgReport
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
    
        def set_envrionment(name: "")
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
    
            if @data_provider[:features].key? name
                @data_provider[:features][name][0]+=1
                @data_provider[:features][name][(test_pass) ? 1 : 2]+=1
            else
                @data_provider[:features][name]=[0,0,0]
                @data_provider[:features][name][0]+=1
                @data_provider[:features][name][(test_pass) ? 1 : 2]+=1
            end
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
    
        def htmlize(features)
            html_content = ''
            features.each do |name, metrics|
                html_content += "\n<div class=\"module dark #{metrics[2] != 0 ? 'danger' : ''} \">
                                  <div class=\"funcname\">
                                    <h4>#{name}</h4>
                                  </div>
                                  <div class=\"total\">
                                    <h6>Total</h6>
                                    <h4>#{metrics[0]}</h4>
                                  </div>
                                  <div class=\"pass\">
                                    <h6>Passed</h6>
                                    <h4>#{metrics[1]}</h4>
                                  </div>
                                  <div class=\"fail\">
                                    <h6>Failed</h6>
                                    <h4>#{metrics[2]}</h4>
                                  </div>
                                </div>"
            end
            return html_content
        end
    
        def write()
            clean()
            if @data_provider[:features].length == 0
                log("No tests logged, cannot build empty report.")
                return
            end
            template = File.new(@data_provider[:report_path], 'w')
            template.puts("<html lang=\"en\">
            <head>
              <meta charset=\"UTF-8\" />
              <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />
              <title id=\"meta-app-title\"></title>
              <link
                href=\"https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300;0,400;0,600;0,700;0,800;1,300;1,400;1,600;1,700;1,800&display=swap\"
                rel=\"stylesheet\"
              />
              <link
                href=\"https://fonts.googleapis.com/icon?family=Material+Icons\"
                rel=\"stylesheet\"
              />
              <style>
                :root {
                  --dark-bg: rgb(41, 40, 40);
                  --dark-primary: #050505;
                  --dark-font: rgb(201, 201, 201);
                  --dark-blue: rgb(0, 225, 255);
                  --dark-green: rgba(115, 255, 0, 0.89);
                  --dark-red: rgb(255, 0, 0);
          
                  --light-bg: rgb(226, 226, 226);
                  --light-primary: #fff;
                  --light-font: rgb(44, 44, 44);
                  --light-blue: rgb(1, 67, 165);
                  --light-green: rgb(14, 138, 2);
                  --light-red: rgb(255, 0, 0);
          
                  --font: \"Open Sans\", sans-serif;
                  --danger-bg: rgba(255, 0, 0, 0.185);
                }
          
                body {
                  font-family: var(--font);
                  margin: auto;
                }
          
                .wrapper {
                  display: grid;
                  grid-template-rows: auto auto 1fr;
                  height: 100vh;
                  width: 100vw;
                }
          
                .header {
                  display: grid;
                  grid-template-columns: 6fr 1fr;
                  text-align: center;
                  #{@data_provider[:title_color]}
                }
    
                .test-config-area {
                  padding-top: 2em;
                  display: flex;
                  flex-wrap: wrap;
                  justify-content: space-around;
                  text-align: center;
                }
    
                .config-item {
                  display: flex;
                  
                }
    
                .config-item-icon {
                  font-size: 2em;
                  padding-right: 0.5em;
                }
          
                .mc {
                  display: grid;
                  grid-template-columns: 1fr 1fr 1fr;
                  grid-auto-rows: 70px;
                  grid-gap: 0.5em;
                  padding: 0.5em 2em;
                  padding-top: 2em;
                }
          
                .footer {
                margin-bottom: 1em;
                padding: 3em;
                text-align: center;
                font-size: 0.7rem;
                font-weight: 600;
                }
    
                a {
                  cursor: pointer;
                  font-weight: 600;
                }
          
                .module {
                  display: grid;
                  place-items: center;
                  grid-template-columns: 3fr 1fr 1fr 1fr;
                  border-radius: 0.7rem;
                  padding: 10px 10px;
                }
          
                .button-wrapper {
                  place-items: center;
                }
          
                #theme-switch {
                  width: 5em;
                  height: 5em;
                  background-color: Transparent;
                  background-repeat: no-repeat;
                  border: none;
                  cursor: pointer;
                  overflow: hidden;
                  outline: none;
                  margin: 0;
                  position: relative;
                  top: 50%;
                  -ms-transform: translateY(-50%);
                  transform: translateY(-50%);
                }
          
                h2,
                h3,
                h4,
                h5,
                h6 {
                  text-align: center;
                  margin: auto;
                }
          
                .total,
                .pass,
                .fail {
                  display: grid;
                  width: 100%;
                  height: 100%;
                  place-items: center;
                }
          
                body.dark {
                  background-color: var(--dark-bg);
                  color: var(--dark-font);
                }
          
                body.dark > .wrapper > .footer {
                  color: var(--dark-font);
                }
          
                body.dark > .wrapper > .mc > .module {
                  background-color: var(--dark-primary);
                  color: var(--dark-font);
                }
          
                body.dark > .wrapper > .mc > .module > .total {
                  color: var(--dark-blue);
                }
          
                body.dark > .wrapper > .mc > .module > .pass {
                  color: var(--dark-green);
                }
          
                body.dark > .wrapper > .mc > .module > .fail {
                  color: var(--dark-red);
                }
          
                body.dark > .wrapper > .mc > .module.danger {
                  background-color: rgba(255, 0, 0, 0.185);
                }
          
                body.dark > .wrapper > .header {
                  color: var(--dark-primary);
                }
    
                body.dark > .wrapper > .test-config-area > .config-item {
                  color: var(--dark-font);
                }
    
                body.dark > .wrapper > .footer > p > span > a {
                  color: var(--dark-font);
                }
          
                body.dark > .wrapper > .header > div > button > #theme-switch-icon {
                  color: var(--dark-primary);
                }
          
                body {
                  background-color: var(--light-bg);
                  color: var(--dark-font);
                }
          
                body > .wrapper > .footer {
                  color: var(--light-font);
                }
          
                body > .wrapper > .mc > .module {
                  background-color: var(--light-primary);
                  color: var(--light-font);
                }
          
                body > .wrapper > .mc > .module > .total {
                  color: var(--light-blue);
                }
          
                body > .wrapper > .mc > .module > .pass {
                  color: var(--light-green);
                }
          
                body > .wrapper > .mc > .module > .fail {
                  color: var(--light-red);
                }
          
                body > .wrapper > .mc > .module.danger {
                  background-color: var(--danger-bg);
                }
          
                body > .wrapper > .header {
                  color: var(--light-primary);
                }
    
                body > .wrapper > .test-config-area > .config-item {
                  color: var(--light-font);
                }
    
                body > .wrapper > .footer > p > span > a {
                  color: var(--light-font);
                }
          
                body > .wrapper > .header > div > button > #theme-switch-icon {
                  color: var(--light-primary);
                }
          
                @media only screen and (max-width: 600px) {
                  h1 {
                    font-size: 24px;
                  }
          
                  .mc {
                    grid-template-columns: 1fr;
                    padding: 0.5em 0.5em;
                    padding-top: 1em;
                  }
                }
          
                @media (min-width: 600px) and (max-width: 992px) {
                  .mc {
                    grid-template-columns: 1fr 1fr;
                  }
                }
              </style>
            </head>
            <body class=\"dark\" id=\"app\">
              <div class=\"wrapper\">
                <div class=\"header\">
                  <h1 id=\"app-title\"></h1>
                  <div class=\"button-wrapper\">
                    <button id=\"theme-switch\" onclick=\"handleThemeSwitch()\">
                      <i class=\"material-icons\" id=\"theme-switch-icon\">brightness_2</i>
                    </button>
                  </div>
                </div>
                #{config_htmlize()}
                <div class=\"mc\">
                  #{htmlize(@data_provider[:features])}
                </div>
                <div class=\"footer\">
                  <p>
                    Developed by
                    <span
                      ><a
                        href=\"https://www.linkedin.com/in/balabharathijayaraman\"
                        rel=\"nofollow\"
                        target=\"_blank\"
                        >Balabharathi Jayaraman</a
                      ></span
                    >
                  </p>
                </div>
              </div>
            </body>
            <script>
              var appTitle = \"#{@data_provider[:title]}\";
              var theme = \"dark\";
          
              window.onload = function () {
                document.getElementById(
                  \"meta-app-title\"
                ).innerHTML = `Home | ${appTitle}`;
                document.getElementById(\"app-title\").innerHTML = appTitle;
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
            </script>
          </html>
          ")
          template.close()
        end
    
        def config_htmlize()
    
          if @data_provider.length == 0
            return
          end
    
          return "<div class=\"test-config-area\">
                  #{execution_date_htmlize()}
                  #{device_htmlize()}
                  #{os_htmlize()}
                  #{release_name_htmlize()}
                  #{app_version_htmlize()}
                  #{environment_htmlize()}
                </div>"
        end
    
        def environment_htmlize()
          if !@data_provider.key?(:environment)
            return
          end

          return build_config_item(@data_provider[:environment], "layers")
        end
    
        def app_version_htmlize()
          if !@data_provider.key?(:app_version)
            return
          end

          return build_config_item(@data_provider[:app_version], "info")
        end
    
        def release_name_htmlize()
          if !@data_provider.key?(:release_name)
            return
          end

          return build_config_item(@data_provider[:release_name], "bookmark")
        end
    
        def os_htmlize()
          if !@data_provider.key?(:os)
            return
          end

          return build_config_item(@data_provider[:os], "settings")
        end
    
        def device_htmlize()
          if !@data_provider.key?(:device)
            return
          end

          return build_config_item(@data_provider[:device], "devices_other")
        end
    
        def execution_date_htmlize()
          if !@data_provider.key?(:execution_date)
            return
          end

          return build_config_item(@data_provider[:execution_date], "date_range")
        end

        def build_config_item(name, icon)
          return "<div class=\"config-item\">
                    <i class=\"config-item-icon material-icons\" id=\"theme-switch-icon\"
                      >#{icon}</i
                    >
                    <h5>#{name}</h5>
                  </div>"
        end
    
        private :log, :clean, :write
        private :execution_date_htmlize, :device_htmlize, :os_htmlize, :release_name_htmlize, :app_version_htmlize, :environment_htmlize
        private :htmlize, :config_htmlize, :build_config_item
    end

    private_constant :NxgReport

    def instance(data_provider: Hash.new())
        return NxgReport.new(data_provider)
    end
end