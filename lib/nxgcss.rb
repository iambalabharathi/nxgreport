
module NxgCss

    def has_environment_settings(data_provider)
        data_provider.key?(:environment) || data_provider.key?(:app_version) || data_provider.key?(:release_name) || data_provider.key?(:os) || data_provider.key?(:device) || data_provider.key?(:execution_date)
    end

    def css(data_provider)
        return "<style>
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
                    grid-template-rows: #{has_environment_settings(data_provider) ? "auto auto 1fr" : "auto 1fr"};
                    height: 100vh;
                    width: 100vw;
                    }
            
                    .header {
                    display: grid;
                    grid-template-columns: 6fr 1fr;
                    text-align: center;
                    #{data_provider[:title_color]}
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
                </style>"
    end
end