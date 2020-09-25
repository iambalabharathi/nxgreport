
module NxgCss

    def has_environment_settings(data_provider)
        data_provider.key?(:environment) || data_provider.key?(:app_version) || data_provider.key?(:release_name) || data_provider.key?(:os) || data_provider.key?(:device) || data_provider.key?(:execution_date)
    end

    def css(data_provider)
        "<style>
        :root {
          --font: \"Open Sans\", sans-serif;
          --primary-gradient: linear-gradient(to bottom right, #ff644e, #cb3018);
          --background-color: #f4f4f4;
          --primary-color: #fff;
          --secondary-color: #fff;
          --primary-font-color: #424242;
          --green: rgb(31, 172, 31);
          --red: rgb(214, 7, 7);
          --blue: rgb(0, 89, 255);
          --red-bg: rgba(255, 0, 0, 0.233);
        }
  
        [theme=\"dark\"] {
          --background-color: #252525;
          --primary-color: #2e2e2e;
          --secondary-color: rgba(255, 255, 255, 0.842);
          --primary-font-color: #f9fafccb;
          --green: rgb(6, 207, 6);
          --red: rgb(228, 1, 1);
          --blue: rgb(91, 226, 250);
          --red-bg: rgba(201, 53, 53, 0.479);
        }
  
        * {
          font-family: var(--font);
          color: var(--primary-font-color);
          transition: color 0.5s ease;
          transition: background-color 0.5s ease;
        }
  
        #app {
          background-color: var(--background-color);
          margin: auto;
        }
  
        #header {
          display: grid;
          grid-template-columns: 8fr 1fr;
          text-align: center;
          background: var(--primary-gradient);
        }
  
        #app-title,
        #theme-icon {
          color: var(--background-color);
        }
  
        #sidebar {
          width: 0;
          height: 100%;
          position: fixed;
          z-index: 2;
          top: 0;
          left: 0;
          overflow-x: hidden;
          transition: 1s ease;
          display: flex;
          place-items: center;
          background: var(--primary-gradient);
        }
  
        #sidebar-div {
          margin: auto;
        }
  
        #sidebar-overlay-test-info {
          font-size: 16px;
          margin: 0.5em 0;
        }
  
        #sidebar-overlay {
          width: 60%;
          height: 100%;
          z-index: 1;
          position: fixed;
          top: 0;
          left: 0;
          visibility: hidden;
          display: flex;
          transition: margin-left 1s ease;
          overflow-y: auto;
          background-color: var(--background-color);
        }
  
        #sidebar-overlay-grid {
          display: grid;
          grid-template-rows: auto;
          padding: 1em;
          margin: 0 1em;
          width: 100%;
          height: fit-content;
        }
  
        #sidebar-title-wrap,
        #sidebar-overlay-test-info {
          display: flex;
          place-items: center;
          flex-wrap: wrap;
        }
  
        #sidebar-title,
        #sidebar-status {
          color: var(--secondary-color);
        }
  
        #test-title {
          margin: 0;
        }
  
        h2,
        h3,
        h4,
        h5,
        h6 {
          text-align: center;
          margin: auto;
        }
  
        #error-message {
          flex-basis: 100%;
          margin: 1em 1.5em 0 1.5em;
          display: table-cell;
          vertical-align: middle;
          background-color: var(--primary-color);
          padding: 1em;
          border-radius: 1em;
          font-size: 0.8em;
        }
  
        #body-wrap {
          display: grid;
          grid-template-rows: auto auto 1fr;
          height: 100vh;
          width: 100vw;
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
          margin-right: 1em;
          position: relative;
          top: 50%;
          -ms-transform: translateY(-50%);
          transform: translateY(-50%);
        }
  
        .params-container {
          display: flex;
          flex-wrap: wrap;
          justify-content: space-between;
          text-align: center;
          padding: 1em 2em;
        }
  
        .param-wrap {
          display: flex;
          place-items: center;
        }
  
        .pi {
          font-size: 1.5em;
          padding-right: 0.5em;
        }
  
        #pt {
          font-size: 0.9em;
        }
  
        #filter {
          cursor: pointer;
          border-radius: 1em;
          width: 5em;
          padding: 0.2em 1em;
          background-color: var(--primary-color);
        }
  
        .features-grid {
          display: grid;
          grid-template-columns: 1fr 1fr 1fr;
          grid-auto-rows: 70px;
          grid-gap: 0.5em;
          padding: 0.5em 2em;
        }
  
        .module {
          display: grid;
          place-items: center;
          grid-template-columns: 3fr 1fr 1fr 1fr;
          border-radius: 0.7rem;
          padding: 10px 10px;
          background-color: var(--primary-color);
          cursor: pointer;
        }
  
        .total,
        .pass,
        .fail {
          display: grid;
          width: 100%;
          height: 100%;
          place-items: center;
        }
  
        .total > * {
          color: var(--blue);
        }
  
        .banner {
          margin: auto;
          text-align: center;
        }
  
        .banner-text {
          font-size: 5em;
        }
  
        #footer {
          font-size: 0.7rem;
          text-align: center;
          margin-bottom: 0.5em;
          padding: 3em 3em 1em 3em;
        }
  
        @media (min-width: 600px) and (max-width: 1400px) {
          .pi {
            font-size: 1em;
            padding-right: 0.5em;
          }
  
          #pt {
            font-size: 0.7em;
          }
  
          .funcname {
            font-size: 0.9em;
          }
        }
  
        .green-font,
        .pass > * {
          color: var(--green);
        }
  
        .red-font,
        .fail > * {
          color: var(--red);
        }
  
        .red-bg {
          background-color: var(--red-bg);
        }
      </style>"
    end
end