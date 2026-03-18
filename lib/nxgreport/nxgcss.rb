
module NxgCss

    def has_environment_settings(data_provider)
        data_provider.key?(:environment) || data_provider.key?(:app_version) || data_provider.key?(:release_name) || data_provider.key?(:os) || data_provider.key?(:device) || data_provider.key?(:execution_date)
    end

    def css(data_provider)
        "<style>
        :root {
          --font: \"DM Sans\", sans-serif;
          --background-color: #f5f5f4;
          --primary-color: #ffffff;
          --primary-font-color: #292524;
          --muted-font-color: #78716c;
          --border-color: #e7e5e4;
          --green: #65a30d;
          --green-bg: #f7fee7;
          --red: #b91c1c;
          --red-bg: #fef2f2;
          --blue: #4b6a8a;
          --blue-bg: #f0f4f8;
          --amber: #92400e;
          --amber-bg: #fffbeb;
          --accent: #57534e;
          --accent-light: #f5f5f4;
          --shadow-sm: 0 1px 2px rgba(0,0,0,0.04);
          --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.06), 0 2px 4px -2px rgba(0,0,0,0.04);
          --radius: 10px;
        }

        [theme=\"dark\"] {
          --background-color: #1c1917;
          --primary-color: #292524;
          --primary-font-color: #e7e5e4;
          --muted-font-color: #a8a29e;
          --border-color: #44403c;
          --green: #a3e635;
          --green-bg: #365314aa;
          --red: #fca5a5;
          --red-bg: #450a0aaa;
          --blue: #93c5fd;
          --blue-bg: #1e3a5faa;
          --amber: #fbbf24;
          --amber-bg: #451a03aa;
          --accent: #a8a29e;
          --accent-light: #44403caa;
          --shadow-sm: 0 1px 2px rgba(0,0,0,0.2);
          --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.3);
        }

        * {
          margin: 0; padding: 0; box-sizing: border-box;
          font-family: var(--font); color: var(--primary-font-color);
        }

        body {
          background-color: var(--background-color);
          transition: background-color 0.3s ease, color 0.3s ease;
          min-height: 100vh;
        }

        #app {
          background-color: var(--background-color);
          max-width: 1200px;
          margin: 0 auto;
          padding: 0 32px 24px;
        }

        /* ---- Header ---- */
        #header {
          display: flex; align-items: center; justify-content: space-between;
          padding: 18px 0;
          border-bottom: 1px solid var(--border-color);
          margin-bottom: 20px;
        }
        #header-left {
          display: flex; align-items: center; gap: 10px;
        }
        #header-logo { font-size: 24px; line-height: 1; }

        #app-title { font-size: 1.3rem; font-weight: 700; letter-spacing: -0.01em; }
        #app-subtitle {
          font-size: 0.72rem; font-weight: 500; color: var(--muted-font-color);
          margin-top: 1px;
        }

        #theme-switch {
          width: 34px; height: 34px;
          background-color: var(--primary-color);
          border: 1px solid var(--border-color); border-radius: 8px;
          cursor: pointer; display: grid; place-items: center;
          box-shadow: var(--shadow-sm); transition: all 0.2s ease;
        }
        #theme-switch:hover { box-shadow: var(--shadow-md); border-color: var(--accent); }
        #theme-icon { color: var(--muted-font-color); font-size: 17px; }

        /* ---- Metadata Chips ---- */
        #meta-bar {
          display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 18px;
        }
        .meta-chip {
          display: flex; align-items: center; gap: 5px;
          background-color: var(--primary-color);
          padding: 4px 12px; border-radius: 20px;
          border: 1px solid var(--border-color);
          font-size: 0.75rem; box-shadow: var(--shadow-sm);
        }
        .meta-emoji { font-size: 13px; line-height: 1; }
        .meta-chip span { color: var(--muted-font-color); font-weight: 500; }

        /* ---- Health Banner ---- */
        #health-banner {
          display: flex; align-items: center; gap: 16px;
          background-color: var(--primary-color);
          border: 1px solid var(--border-color);
          border-radius: var(--radius);
          padding: 16px 24px;
          margin-bottom: 18px;
          box-shadow: var(--shadow-sm);
        }
        .health-emoji { font-size: 42px; line-height: 1; }
        .health-text h3 { text-align: left; margin: 0; font-size: 1rem; font-weight: 700; }
        .health-text p {
          text-align: left; margin: 3px 0 0 0;
          font-size: 0.8rem; color: var(--muted-font-color); font-weight: 400;
          line-height: 1.4;
        }

        /* ---- Stats Cards ---- */
        #stats-grid {
          display: grid; grid-template-columns: repeat(4, 1fr);
          gap: 12px; margin-bottom: 18px;
        }
        .stat-card {
          background-color: var(--primary-color);
          border-radius: var(--radius); padding: 14px 16px;
          box-shadow: var(--shadow-sm); border: 1px solid var(--border-color);
          transition: all 0.2s ease;
        }
        .stat-card:hover { box-shadow: var(--shadow-md); transform: translateY(-1px); }
        .stat-label {
          font-size: 0.68rem; font-weight: 600; text-transform: uppercase;
          letter-spacing: 0.05em; color: var(--muted-font-color); margin-bottom: 5px;
        }
        .stat-value { font-size: 1.6rem; font-weight: 800; line-height: 1; }
        .stat-value.green { color: var(--green); }
        .stat-value.red { color: var(--red); }
        .stat-value.blue { color: var(--blue); }
        .stat-value.amber { color: var(--amber); }
        .stat-emoji {
          float: right; font-size: 24px; line-height: 1; margin-top: -2px;
        }

        /* ---- Section Titles ---- */
        .section-title {
          font-size: 0.95rem; font-weight: 700; text-align: left; margin: 0;
          letter-spacing: -0.01em;
        }

        /* ---- Features Section ---- */
        #features-header {
          display: flex; align-items: center; justify-content: space-between;
          margin-bottom: 10px;
        }

        #filter {
          display: flex; align-items: center; gap: 5px;
          padding: 5px 12px; border-radius: 8px;
          background-color: var(--primary-color);
          border: 1px solid var(--border-color);
          cursor: pointer; font-size: 0.75rem; font-weight: 600;
          box-shadow: var(--shadow-sm); transition: all 0.2s ease;
        }
        #filter:hover { border-color: var(--accent); box-shadow: var(--shadow-md); }
        .filter-emoji { font-size: 13px; line-height: 1; }
        #filter h5 { text-align: left; margin: 0; font-weight: 600; font-size: 0.75rem; }

        /* Feature grid */
        .features-grid {
          display: grid;
          grid-template-columns: repeat(3, 1fr);
          gap: 10px;
        }

        .module {
          display: flex; flex-direction: column;
          background-color: var(--primary-color);
          border: 1px solid var(--border-color);
          border-radius: var(--radius);
          padding: 14px 16px;
          cursor: pointer; box-shadow: var(--shadow-sm);
          transition: all 0.2s ease;
        }
        .module:hover { box-shadow: var(--shadow-md); transform: translateY(-1px); border-color: var(--accent); }
        .module.red-bg { border-left: 3px solid var(--red); }

        .funcname { display: flex; align-items: center; justify-content: space-between; margin: 0 0 8px 0; }
        .funcname h4 { text-align: left; margin: 0; font-size: 0.85rem; font-weight: 600; }
        .feature-status-icon {
          width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center;
          font-size: 14px; flex-shrink: 0;
        }
        .feature-status-icon.pass { background: rgba(101,163,13,0.12); }
        .feature-status-icon.fail { background: rgba(185,28,28,0.12); }

        .module-stats {
          display: flex; gap: 14px; margin-bottom: 8px;
        }

        .total, .pass, .fail {
          display: flex; align-items: center; gap: 3px;
        }
        .total h6, .pass h6, .fail h6 {
          text-align: left; margin: 0; font-size: 0.62rem; font-weight: 600;
          text-transform: uppercase; letter-spacing: 0.03em; color: var(--muted-font-color);
        }
        .total h4, .pass h4, .fail h4 {
          text-align: left; margin: 0; font-size: 0.82rem; font-weight: 700;
        }
        .total > * { color: var(--blue); }
        .pass > * { color: var(--green); }
        .fail > * { color: var(--red); }

        .progress-wrap { display: flex; align-items: center; gap: 8px; }
        .progress-bar {
          flex: 1; height: 4px; background-color: var(--border-color);
          border-radius: 2px; overflow: hidden;
        }
        .progress-fill { height: 100%; background-color: var(--green); border-radius: 2px; transition: width 0.4s ease; }
        .progress-text { font-size: 0.68rem; font-weight: 700; color: var(--muted-font-color); min-width: 30px; text-align: right; }

        /* Banner */
        .banner { display: grid; place-items: center; padding: 50px 0; grid-column: 1 / -1; }
        .banner-text { font-size: 3.5rem; }
        .banner h1 { text-align: center; color: var(--muted-font-color); font-weight: 600; margin-top: 8px; font-size: 1.1rem; }

        /* ---- Modal ---- */
        #modal {
          position: fixed; z-index: 100;
          top: 50%; left: 50%;
          transform: translate(-50%, -50%) scale(0.95);
          width: 90%; max-width: 640px; max-height: 80vh;
          background: var(--primary-color);
          border: 1px solid var(--border-color);
          border-radius: 16px;
          box-shadow: 0 25px 50px -12px rgba(0,0,0,0.15);
          opacity: 0; visibility: hidden;
          transition: all 0.25s cubic-bezier(0.4,0,0.2,1);
          display: flex; flex-direction: column;
          overflow: hidden;
        }
        #modal.active {
          opacity: 1; visibility: visible;
          transform: translate(-50%, -50%) scale(1);
        }
        #modal-header {
          display: flex; align-items: center; justify-content: space-between;
          padding: 18px 22px 0;
          flex-shrink: 0;
        }
        #modal-title-wrap {
          display: flex; align-items: center; gap: 8px;
        }
        #modal-status-emoji { font-size: 22px; line-height: 1; }
        #modal-title {
          font-size: 1.05rem; font-weight: 700; margin: 0; text-align: left;
        }
        #modal-close {
          width: 32px; height: 32px; border-radius: 8px;
          background: var(--background-color); border: 1px solid var(--border-color);
          cursor: pointer; display: grid; place-items: center;
          transition: all 0.15s ease; flex-shrink: 0;
        }
        #modal-close:hover { background: var(--border-color); }
        #modal-close i { font-size: 18px; color: var(--muted-font-color); }

        #modal-tags {
          display: flex; flex-wrap: wrap; gap: 5px;
          padding: 10px 22px 0;
        }

        #modal-summary {
          display: flex; gap: 16px; padding: 14px 22px;
          border-bottom: 1px solid var(--border-color);
          flex-shrink: 0;
        }
        .modal-stat {
          display: flex; align-items: center; gap: 5px;
          font-size: 0.78rem; font-weight: 600;
        }
        .modal-stat .ms-num { font-weight: 800; }
        .modal-stat.t-pass .ms-num { color: var(--green); }
        .modal-stat.t-fail .ms-num { color: var(--red); }
        .modal-stat.t-total .ms-num { color: var(--blue); }

        #modal-tests {
          overflow-y: auto; padding: 14px 22px 18px;
          display: flex; flex-direction: column; gap: 6px;
          flex: 1;
        }

        .test-row {
          display: flex; align-items: flex-start; flex-wrap: wrap; gap: 6px;
          padding: 10px 12px;
          background: var(--background-color);
          border-radius: var(--radius); border: 1px solid var(--border-color);
        }
        .test-row-emoji { font-size: 1rem; line-height: 1.3; flex-shrink: 0; }
        .test-row-title {
          margin: 0; font-size: 0.82rem; font-weight: 600; flex: 1; text-align: left;
          line-height: 1.3;
        }
        .test-row-time {
          font-size: 0.63rem; font-weight: 600; background: var(--accent);
          color: #fff; padding: 2px 9px; border-radius: 12px;
          flex-shrink: 0;
        }
        .test-row-tag {
          font-size: 0.62rem; font-weight: 600;
          padding: 2px 8px; border-radius: 10px;
          background-color: var(--accent-light);
          color: var(--accent); border: 1px solid var(--border-color);
        }
        .test-row-error {
          flex-basis: 100%; margin-top: 4px; padding: 8px 10px;
          background: var(--red-bg); border-radius: 8px;
          font-size: 0.75rem; color: var(--red); line-height: 1.4;
          border: 1px solid var(--border-color);
        }

        #backdrop {
          position: fixed; top: 0; left: 0; width: 100%; height: 100%;
          background: rgba(0,0,0,0.3); z-index: 98;
          opacity: 0; visibility: hidden; transition: all 0.25s ease;
          backdrop-filter: blur(3px);
        }
        #backdrop.active { opacity: 1; visibility: visible; }

        .green-font { color: var(--green); }
        .red-font { color: var(--red); }

        h2,h3,h4,h5,h6 { text-align: center; margin: auto; }

        /* ---- Tag Filter Section ---- */
        #tag-section { margin-bottom: 18px; }
        #tag-filters {
          display: flex; flex-wrap: wrap; gap: 7px; margin: 10px 0 14px 0;
        }
        .tag-chip {
          display: flex; align-items: center; gap: 5px;
          padding: 4px 13px; border-radius: 18px;
          background-color: var(--primary-color);
          border: 1.5px solid var(--border-color);
          cursor: pointer; font-size: 0.75rem; font-weight: 600;
          box-shadow: var(--shadow-sm); transition: all 0.2s ease;
        }
        .tag-chip:hover { border-color: var(--accent); }
        .tag-chip.active { border-color: var(--accent); background-color: var(--accent-light); }
        .tag-chip .tag-name { color: var(--primary-font-color); }
        .tag-chip .tag-count {
          font-size: 0.65rem; font-weight: 700;
          background-color: var(--border-color); color: var(--muted-font-color);
          padding: 1px 7px; border-radius: 10px;
        }
        .tag-chip.active .tag-count {
          background-color: var(--accent); color: #fff;
        }

        /* ---- Charts Grid ---- */
        #charts-grid {
          display: grid;
          grid-template-columns: 280px 1fr;
          gap: 12px;
        }

        /* ---- Tag Chart ---- */
        #tag-chart, #pie-chart-card {
          background-color: var(--primary-color);
          border: 1px solid var(--border-color);
          border-radius: var(--radius);
          padding: 16px 18px;
          box-shadow: var(--shadow-sm);
        }
        .chart-title {
          font-size: 0.75rem; font-weight: 600; text-align: left; margin: 0 0 12px 0;
          color: var(--muted-font-color); text-transform: uppercase; letter-spacing: 0.04em;
        }
        #tag-chart-legend {
          display: flex; gap: 14px; margin-bottom: 8px;
        }
        .legend-item {
          display: flex; align-items: center; gap: 5px; font-size: 0.72rem; font-weight: 600;
          color: var(--muted-font-color);
        }
        .legend-dot {
          width: 8px; height: 8px; border-radius: 50%;
        }
        .legend-dot.pass { background-color: var(--green); }
        .legend-dot.fail { background-color: var(--red); }
        #line-chart-svg {
          width: 100%; height: 200px;
        }
        .chart-grid-line { stroke: var(--border-color); stroke-width: 1; }
        .chart-axis-label {
          font-size: 11px; font-family: var(--font);
          fill: var(--muted-font-color); font-weight: 500;
        }
        .chart-y-label {
          font-size: 10px; font-family: var(--font);
          fill: var(--muted-font-color); font-weight: 600;
        }
        .line-pass {
          fill: none; stroke: var(--green); stroke-width: 2.5;
          stroke-linecap: round; stroke-linejoin: round;
        }
        .line-fail {
          fill: none; stroke: var(--red); stroke-width: 2.5;
          stroke-linecap: round; stroke-linejoin: round;
        }
        .area-pass { fill: var(--green); opacity: 0.08; }
        .area-fail { fill: var(--red); opacity: 0.08; }
        .dot-pass { fill: var(--green); stroke: var(--primary-color); stroke-width: 2; }
        .dot-fail { fill: var(--red); stroke: var(--primary-color); stroke-width: 2; }

        /* ---- Pie Chart ---- */
        #pie-chart-card {
          display: flex; flex-direction: column; align-items: center;
        }
        #pie-chart-wrap {
          width: 160px; height: 160px; position: relative; margin: 4px 0;
        }
        #pie-chart-svg {
          width: 100%; height: 100%;
          transform: rotate(-90deg);
        }
        .pie-slice { transition: opacity 0.2s ease; }
        .pie-slice:hover { opacity: 0.75; }
        #pie-center-label {
          position: absolute; top: 50%; left: 50%;
          transform: translate(-50%, -50%);
          text-align: center;
        }
        #pie-center-label .pie-total-num {
          font-size: 1.5rem; font-weight: 800; line-height: 1;
        }
        #pie-center-label .pie-total-lbl {
          font-size: 0.6rem; font-weight: 600; text-transform: uppercase;
          color: var(--muted-font-color); letter-spacing: 0.04em;
        }
        #pie-chart-legend {
          display: flex; flex-direction: column; gap: 5px;
          margin-top: 10px; width: 100%;
        }
        .pie-legend-item {
          display: flex; align-items: center; gap: 8px;
          font-size: 0.75rem; font-weight: 600;
        }
        .pie-legend-dot {
          width: 8px; height: 8px; border-radius: 2px; flex-shrink: 0;
        }
        .pie-legend-label { flex: 1; color: var(--muted-font-color); }
        .pie-legend-value { font-weight: 700; }

        /* ---- Tag badges ---- */
        .module-tags {
          display: flex; flex-wrap: wrap; gap: 4px; margin-top: 8px;
        }
        .module-tag {
          font-size: 0.62rem; font-weight: 600;
          padding: 2px 8px; border-radius: 10px;
          background-color: var(--accent-light);
          color: var(--accent); border: 1px solid var(--border-color);
        }

        #footer {
          font-size: 0.7rem; text-align: center; padding: 24px 0 12px;
          color: var(--muted-font-color);
        }
        #footer p, #footer a { color: var(--muted-font-color); }
        #footer a { text-decoration: none; font-weight: 600; }
        #footer a:hover { color: var(--primary-font-color); }

        @media (max-width: 900px) {
          #stats-grid { grid-template-columns: repeat(2, 1fr); }
          .features-grid { grid-template-columns: repeat(2, 1fr); }
          #charts-grid { grid-template-columns: 1fr; }
        }
        @media (max-width: 600px) {
          .features-grid { grid-template-columns: 1fr; }
          #app { padding: 0 16px 16px; }
        }
      </style>"
    end
end
