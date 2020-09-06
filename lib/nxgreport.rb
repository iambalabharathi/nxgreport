require 'fileutils'

class NxgReport

    attr_reader :nxg_report_path, :auto_open, :title, :features, :title_color

    def setup(location: "./NxgReport.html", title: "Features Summary")
        @nxg_report_path = location.empty? ? "./NxgReport.html" : location
        folder_check()
        @title = title
        @title_color = ''
        @auto_open = false
        @features = Hash.new()
    end

    def open_upon_execution(value:true)
        @auto_open = value
    end

    def set_title_color(hex_color: "")
        if !hex_color[0].eql?("#")
          log("Invalid hex color passed for report title #{hex_color}")
          return
        end
        @title_color = hex_color
    end

    def log_test(feature_name, test_status)
        if feature_name.nil?() || feature_name.strip.empty?()
          log("Feature name cannot be empty.")
          return
        end
        test_pass = test_status.downcase.include?('pass')
        name = feature_name.strip()

        if @features.key? name
            @features[name][0]+=1
            @features[name][(test_pass) ? 1 : 2]+=1
        else
            @features[name]=[0,0,0]
            @features[name][0]+=1
            @features[name][(test_pass) ? 1 : 2]+=1
        end
    end

    def build()
        write()
        if @auto_open && report_success()
            system("open #{@nxg_report_path}")
        end
    end

    # Private methods
    def log(message)
        puts("🤖- #{message}")
    end

    def folder_check()
      folder = File.dirname(@nxg_report_path)
      FileUtils.mkdir_p(folder) unless File.directory?(folder)
    end

    def report_success()
      return File.file?(@nxg_report_path)
    end

    def clean()
        File.delete(@nxg_report_path) if File.file?(@nxg_report_path)
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
        if @features.length == 0
            log("No tests logged, cannot build empty report.")
            return
        end
        clean()
        template = File.new(@nxg_report_path, 'w')
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
              grid-template-rows: auto 1fr;
              height: 100vh;
              width: 100vw;
            }
      
            .header {
              display: grid;
              grid-template-columns: 6fr 1fr;
              text-align: center;
              #{@title_color.empty?() ? "background: linear-gradient(to bottom right, #ff644e, #cb3018);" : "background-color: #{@title_color}"}
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
            <div class=\"mc\">
              #{htmlize(@features)}
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
          var appTitle = \"#{@title}\";
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

    private :log, :clean, :write, :htmlize, :report_success
end

$NxgReport = NxgReport.new()