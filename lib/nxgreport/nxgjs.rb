
module NxgJavascript

    def js_detect_system_dark_mode()
        "if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            $(document.documentElement).attr(\"theme\", \"dark\");
        }"
    end

    def js(data_provider)

        js_array = data_provider[:features].to_s.gsub("=>", ":")

        return "<script>
                    const allFeatures = #{js_array};
                    const STATUS = { pass: \"check_circle\", fail: \"cancel\", };
                    var displayFailuresOnly = false;
                    var dataSource = [];
                    var activeTag = null;
                    var tagData = {};

                    function buildTagData() {
                        tagData = {};
                        allFeatures.forEach(function(feature) {
                            feature.tests.forEach(function(test) {
                                if (test.tag && test.tag !== \"\") {
                                    var t = test.tag.toLowerCase();
                                    if (!tagData[t]) { tagData[t] = { total: 0, pass: 0, fail: 0 }; }
                                    tagData[t].total++;
                                    if (test.testPass) { tagData[t].pass++; } else { tagData[t].fail++; }
                                }
                            });
                        });
                    }

                    function renderTagFilters() {
                        $(\"#tag-filters\").empty();
                        var tagNames = Object.keys(tagData).sort();

                        // \"All\" chip
                        $(\"#tag-filters\").append(
                            `<div class=\"tag-chip ${activeTag === null ? 'active' : ''}\" onclick=\"filterByTag(null)\">
                                <span class=\"tag-name\">\u{1F4CB} All</span>
                                <span class=\"tag-count\">${allFeatures.reduce(function(s,f){return s+f.total},0)}</span>
                            </div>`
                        );

                        var tagEmojis = { smoke: \"\u{1F4A8}\", critical: \"\u{1F525}\", regression: \"\u{1F504}\", integration: \"\u{1F517}\", unit: \"\u{1F9E9}\", performance: \"\u{26A1}\", security: \"\u{1F512}\", ui: \"\u{1F3A8}\", api: \"\u{1F310}\" };
                        tagNames.forEach(function(tag) {
                            var d = tagData[tag];
                            var emoji = tagEmojis[tag] || \"\u{1F3F7}\uFE0F\";
                            $(\"#tag-filters\").append(
                                `<div class=\"tag-chip ${activeTag === tag ? 'active' : ''}\" onclick=\"filterByTag('${tag}')\">
                                    <span class=\"tag-name\">${emoji} ${tag}</span>
                                    <span class=\"tag-count\">${d.total}</span>
                                </div>`
                            );
                        });
                    }

                    function renderTagChart() {
                        var svg = $(\"#line-chart-svg\");
                        svg.empty();
                        var tagNames = Object.keys(tagData).sort();
                        if (tagNames.length === 0) return;

                        var svgW = svg.width() || 600;
                        var svgH = 200;
                        svg.attr(\"viewBox\", \"0 0 \" + svgW + \" \" + svgH);

                        var padL = 40, padR = 20, padT = 15, padB = 35;
                        var chartW = svgW - padL - padR;
                        var chartH = svgH - padT - padB;

                        var maxVal = 0;
                        tagNames.forEach(function(t) {
                            if (tagData[t].pass > maxVal) maxVal = tagData[t].pass;
                            if (tagData[t].fail > maxVal) maxVal = tagData[t].fail;
                        });
                        maxVal = Math.max(maxVal, 1);
                        // Round up to nice number
                        var gridStep = Math.ceil(maxVal / 4);
                        maxVal = gridStep * 4;

                        var ns = \"http://www.w3.org/2000/svg\";

                        // Grid lines + Y labels
                        for (var i = 0; i <= 4; i++) {
                            var y = padT + chartH - (i / 4) * chartH;
                            var line = document.createElementNS(ns, \"line\");
                            line.setAttribute(\"x1\", padL); line.setAttribute(\"x2\", svgW - padR);
                            line.setAttribute(\"y1\", y); line.setAttribute(\"y2\", y);
                            line.setAttribute(\"class\", \"chart-grid-line\");
                            svg.append(line);

                            var label = document.createElementNS(ns, \"text\");
                            label.setAttribute(\"x\", padL - 8); label.setAttribute(\"y\", y + 4);
                            label.setAttribute(\"class\", \"chart-y-label\");
                            label.setAttribute(\"text-anchor\", \"end\");
                            label.textContent = i * gridStep;
                            svg.append(label);
                        }

                        // Compute points
                        var passPoints = [];
                        var failPoints = [];
                        tagNames.forEach(function(tag, idx) {
                            var x = tagNames.length === 1
                                ? padL + chartW / 2
                                : padL + (idx / (tagNames.length - 1)) * chartW;
                            var yPass = padT + chartH - (tagData[tag].pass / maxVal) * chartH;
                            var yFail = padT + chartH - (tagData[tag].fail / maxVal) * chartH;
                            passPoints.push({ x: x, y: yPass });
                            failPoints.push({ x: x, y: yFail });

                            // X axis label
                            var lbl = document.createElementNS(ns, \"text\");
                            lbl.setAttribute(\"x\", x); lbl.setAttribute(\"y\", svgH - 5);
                            lbl.setAttribute(\"class\", \"chart-axis-label\");
                            lbl.setAttribute(\"text-anchor\", \"middle\");
                            lbl.textContent = \"#\" + tag;
                            svg.append(lbl);
                        });

                        // Area fills
                        var baseY = padT + chartH;
                        var passAreaD = \"M\" + passPoints.map(function(p){return p.x+\",\"+p.y}).join(\" L\") + \" L\" + passPoints[passPoints.length-1].x + \",\" + baseY + \" L\" + passPoints[0].x + \",\" + baseY + \" Z\";
                        var failAreaD = \"M\" + failPoints.map(function(p){return p.x+\",\"+p.y}).join(\" L\") + \" L\" + failPoints[failPoints.length-1].x + \",\" + baseY + \" L\" + failPoints[0].x + \",\" + baseY + \" Z\";

                        var passArea = document.createElementNS(ns, \"path\");
                        passArea.setAttribute(\"d\", passAreaD);
                        passArea.setAttribute(\"class\", \"area-pass\");
                        svg.append(passArea);

                        var failArea = document.createElementNS(ns, \"path\");
                        failArea.setAttribute(\"d\", failAreaD);
                        failArea.setAttribute(\"class\", \"area-fail\");
                        svg.append(failArea);

                        // Lines
                        var passD = \"M\" + passPoints.map(function(p){return p.x+\",\"+p.y}).join(\" L\");
                        var failD = \"M\" + failPoints.map(function(p){return p.x+\",\"+p.y}).join(\" L\");

                        var passLine = document.createElementNS(ns, \"path\");
                        passLine.setAttribute(\"d\", passD);
                        passLine.setAttribute(\"class\", \"line-pass\");
                        svg.append(passLine);

                        var failLine = document.createElementNS(ns, \"path\");
                        failLine.setAttribute(\"d\", failD);
                        failLine.setAttribute(\"class\", \"line-fail\");
                        svg.append(failLine);

                        // Dots + value labels
                        passPoints.forEach(function(p, idx) {
                            var dot = document.createElementNS(ns, \"circle\");
                            dot.setAttribute(\"cx\", p.x); dot.setAttribute(\"cy\", p.y);
                            dot.setAttribute(\"r\", 5); dot.setAttribute(\"class\", \"dot-pass\");
                            svg.append(dot);
                            var val = document.createElementNS(ns, \"text\");
                            val.setAttribute(\"x\", p.x); val.setAttribute(\"y\", p.y - 10);
                            val.setAttribute(\"class\", \"chart-axis-label\");
                            val.setAttribute(\"text-anchor\", \"middle\");
                            val.textContent = tagData[tagNames[idx]].pass;
                            svg.append(val);
                        });
                        failPoints.forEach(function(p, idx) {
                            var dot = document.createElementNS(ns, \"circle\");
                            dot.setAttribute(\"cx\", p.x); dot.setAttribute(\"cy\", p.y);
                            dot.setAttribute(\"r\", 5); dot.setAttribute(\"class\", \"dot-fail\");
                            svg.append(dot);
                            var val = document.createElementNS(ns, \"text\");
                            val.setAttribute(\"x\", p.x); val.setAttribute(\"y\", p.y - 10);
                            val.setAttribute(\"class\", \"chart-axis-label\");
                            val.setAttribute(\"text-anchor\", \"middle\");
                            val.textContent = tagData[tagNames[idx]].fail;
                            svg.append(val);
                        });
                    }

                    function renderPieChart() {
                        var svg = $(\"#pie-chart-svg\");
                        svg.empty();
                        $(\"#pie-chart-legend\").empty();

                        var totalTests = allFeatures.reduce(function(s,f){return s+f.total},0);
                        var totalPass = allFeatures.reduce(function(s,f){return s+f.pass},0);
                        var totalFail = allFeatures.reduce(function(s,f){return s+f.fail},0);

                        var slices = [
                            { label: \"\u{2705} Passed\", value: totalPass, color: \"var(--green)\" },
                            { label: \"\u{274C} Failed\", value: totalFail, color: \"var(--red)\" }
                        ];

                        var ns = \"http://www.w3.org/2000/svg\";
                        var cx = 120, cy = 120, r = 90, innerR = 60;
                        var startAngle = 0;

                        slices.forEach(function(slice) {
                            if (slice.value === 0) return;
                            var fraction = slice.value / totalTests;
                            var endAngle = startAngle + fraction * 2 * Math.PI;

                            // For full circle (100%), use two arcs
                            if (fraction >= 0.9999) {
                                var d = \"M\" + (cx+r) + \",\" + cy +
                                    \" A\" + r + \",\" + r + \" 0 1,1 \" + (cx-r) + \",\" + cy +
                                    \" A\" + r + \",\" + r + \" 0 1,1 \" + (cx+r) + \",\" + cy +
                                    \" M\" + (cx+innerR) + \",\" + cy +
                                    \" A\" + innerR + \",\" + innerR + \" 0 1,0 \" + (cx-innerR) + \",\" + cy +
                                    \" A\" + innerR + \",\" + innerR + \" 0 1,0 \" + (cx+innerR) + \",\" + cy + \" Z\";
                            } else {
                                var x1o = cx + r * Math.cos(startAngle);
                                var y1o = cy + r * Math.sin(startAngle);
                                var x2o = cx + r * Math.cos(endAngle);
                                var y2o = cy + r * Math.sin(endAngle);
                                var x1i = cx + innerR * Math.cos(endAngle);
                                var y1i = cy + innerR * Math.sin(endAngle);
                                var x2i = cx + innerR * Math.cos(startAngle);
                                var y2i = cy + innerR * Math.sin(startAngle);
                                var largeArc = fraction > 0.5 ? 1 : 0;

                                var d = \"M\" + x1o + \",\" + y1o +
                                    \" A\" + r + \",\" + r + \" 0 \" + largeArc + \",1 \" + x2o + \",\" + y2o +
                                    \" L\" + x1i + \",\" + y1i +
                                    \" A\" + innerR + \",\" + innerR + \" 0 \" + largeArc + \",0 \" + x2i + \",\" + y2i +
                                    \" Z\";
                            }

                            var path = document.createElementNS(ns, \"path\");
                            path.setAttribute(\"d\", d);
                            path.setAttribute(\"fill\", slice.color);
                            path.setAttribute(\"class\", \"pie-slice\");
                            svg.append(path);

                            startAngle = endAngle;
                        });

                        // Center label
                        if ($(\"#pie-center-label\").length === 0) {
                            $(\"#pie-chart-wrap\").append(
                                `<div id=\"pie-center-label\">
                                    <div class=\"pie-total-num\">${totalTests}</div>
                                    <div class=\"pie-total-lbl\">Total</div>
                                </div>`
                            );
                        }

                        // Legend
                        slices.forEach(function(slice) {
                            var pct = totalTests > 0 ? Math.round((slice.value / totalTests) * 100) : 0;
                            $(\"#pie-chart-legend\").append(
                                `<div class=\"pie-legend-item\">
                                    <span class=\"pie-legend-dot\" style=\"background-color:${slice.color}\"></span>
                                    <span class=\"pie-legend-label\">${slice.label}</span>
                                    <span class=\"pie-legend-value\">${slice.value} (${pct}%)</span>
                                </div>`
                            );
                        });
                    }

                    function filterByTag(tag) {
                        activeTag = tag;
                        displayFailuresOnly = false;
                        applyFilters();
                        renderTagFilters();
                    }

                    function applyFilters() {
                        if (activeTag === null) {
                            dataSource = allFeatures;
                        } else {
                            // Filter features to only include tests matching the tag
                            dataSource = [];
                            allFeatures.forEach(function(feature) {
                                var matchingTests = feature.tests.filter(function(test) {
                                    return test.tag && test.tag.toLowerCase() === activeTag;
                                });
                                if (matchingTests.length > 0) {
                                    var filtered = {
                                        name: feature.name,
                                        total: matchingTests.length,
                                        pass: matchingTests.filter(function(t){return t.testPass}).length,
                                        fail: matchingTests.filter(function(t){return !t.testPass}).length,
                                        tests: matchingTests
                                    };
                                    dataSource.push(filtered);
                                }
                            });
                        }

                        if (displayFailuresOnly) {
                            $(\"#filter h5\").text(\"Failed\");
                            dataSource = dataSource.filter(function(feature) { return feature.fail > 0; });
                        } else {
                            $(\"#filter h5\").text(\"All\");
                        }

                        updateView();
                    }

                    function onRefresh() {
                        buildTagData();
                        renderTagFilters();
                        renderTagChart();
                        renderPieChart();
                        dataSource = allFeatures;
                        setFilter();
                        currentTheme = $(document.documentElement).attr(\"theme\");
                        $(\"#theme-icon\").text(currentTheme === \"dark\" ? \"brightness_2\" : \"wb_sunny\");
                    }

                    function getFeatureTags(feature) {
                        var tags = {};
                        feature.tests.forEach(function(t) {
                            if (t.tag && t.tag !== \"\") { tags[t.tag.toLowerCase()] = true; }
                        });
                        return Object.keys(tags);
                    }

                    function updateView() {
                        $(\".banner\").removeClass(\"banner\").addClass(\"features-grid\");
                        $(\".features-grid\").empty();

                        if (dataSource.length === 0) {
                          $(\".features-grid\")
                            .removeClass(\"features-grid\")
                            .addClass(\"banner\")
                            .append(
                            `<div class=\"banner-text\">\u{1F389}</div><h1>No Failures \u{2728}\u{1F60E}</h1>`
                            );
                          return;
                        }

                        dataSource.forEach((feature, index) => {
                          var passPercent = feature.total > 0 ? Math.round((feature.pass / feature.total) * 100) : 0;
                          var tags = getFeatureTags(feature);
                          var tagHtml = tags.map(function(t) {
                              return `<span class=\"module-tag\">\u{1F3F7}\uFE0F ${t}</span>`;
                          }).join(\"\");
                          var statusEmoji = feature.fail === 0 ? \"\u{2705}\" : \"\u{26A0}\uFE0F\";
                          $(\".features-grid\").append(
                            `<div class=\"module ${
                              feature.fail > 0 ? \"red-bg\" : \"\"
                            }\" onclick=\"showDetails(${index})\">
                              <div class=\"funcname\"><h4>${feature.name}</h4><span class=\"feature-status-icon ${feature.fail === 0 ? 'pass' : 'fail'}\">${statusEmoji}</span></div>
                              <div class=\"module-stats\">
                                <div class=\"total\"><h6>\u{1F4CB} Total</h6>&nbsp;<h4>${feature.total}</h4></div>
                                <div class=\"pass\"><h6>\u{2705} Pass</h6>&nbsp;<h4>${feature.pass}</h4></div>
                                <div class=\"fail\"><h6>\u{274C} Fail</h6>&nbsp;<h4>${feature.fail}</h4></div>
                              </div>
                              <div class=\"progress-wrap\">
                                <div class=\"progress-bar\"><div class=\"progress-fill\" style=\"width:${passPercent}%\"></div></div>
                                <span class=\"progress-text\">${passPercent}%</span>
                              </div>
                              ${tagHtml ? '<div class=\"module-tags\">' + tagHtml + '</div>' : ''}
                            </div>`
                          );
                        });
                    }

                    function setFilter() {
                        if (displayFailuresOnly) {
                          $(\"#filter h5\").text(\"Failed\");
                        } else {
                          $(\"#filter h5\").text(\"All\");
                        }
                        applyFilters();
                        displayFailuresOnly = !displayFailuresOnly;
                    }

                    function openModal() {
                        $(\"#backdrop\").addClass(\"active\");
                        $(\"#modal\").addClass(\"active\");
                        $('body').css('overflow', 'hidden');
                    }

                    function closeModal() {
                        $(\"#backdrop\").removeClass(\"active\");
                        $(\"#modal\").removeClass(\"active\");
                        $('body').css('overflow', 'auto');
                    }

                    function buildTestRow(test) {
                        var emoji = test.testPass ? \"\u{2705}\" : \"\u{274C}\";
                        var errorHtml = (!test.testPass && test.comments !== \"\") ? `<div class=\"test-row-error\">\u{1F4AC} ${test.comments}</div>` : \"\";
                        var tagHtml = test.tag ? `<span class=\"test-row-tag\">\u{1F3F7}\uFE0F ${test.tag.toLowerCase()}</span>` : \"\";
                        return `<div class=\"test-row\">
                            <span class=\"test-row-emoji\">${emoji}</span>
                            <div class=\"test-row-body\">
                                <div class=\"test-row-title\">${test.name}</div>
                                <div class=\"test-row-meta\">
                                    <span class=\"test-row-time\">\u{23F1}\uFE0F ${test.time}s</span>
                                    ${tagHtml}
                                </div>
                                ${errorHtml}
                            </div>
                        </div>`;
                    }

                    function filterAllFailed() {
                        var allFailedTests = [];
                        var sourceFeatures = activeTag === null ? allFeatures : dataSource;

                        sourceFeatures.forEach(function(feature) {
                            feature.tests.forEach(function(test) {
                                if (!test.testPass) { allFailedTests.push(test); }
                            });
                        });

                        $(\"#modal-status-emoji\").text(\"\u{1F6A8}\");
                        $(\"#modal-title\").text(\"Failed Tests\");
                        $(\"#modal-tags\").empty();
                        $(\"#modal-summary\").html(
                            `<div class=\"modal-stat\"><span class=\"stat-emoji\">\u{274C}</span><span>${allFailedTests.length} failed test${allFailedTests.length !== 1 ? 's' : ''}</span></div>`
                        );
                        $(\"#modal-tests\").empty();
                        allFailedTests.forEach(function(test) {
                            $(\"#modal-tests\").append(buildTestRow(test));
                        });
                        openModal();
                    }

                    function switchTheme() {
                        currentTheme = $(document.documentElement).attr(\"theme\");
                        $(document.documentElement).attr(\"theme\", currentTheme === \"dark\" ? \"light\" : \"dark\");
                        $(\"#theme-icon\").text(currentTheme === \"dark\" ? \"wb_sunny\" : \"brightness_2\");
                    }

                    $(document).on('keydown', function(e) {
                        if (e.key === 'Escape') { closeModal(); }
                    });

                    window
                        .matchMedia(\"(prefers-color-scheme: dark)\")
                        .addEventListener(\"change\", (e) => {
                            darkTheme = e.matches;
                            $(document.documentElement).attr(\"theme\", darkTheme ? \"dark\" : \"light\");
                            $(\"#theme-icon\").text(darkTheme ? \"brightness_2\" : \"wb_sunny\");
                        });

                    function showDetails(featureID) {
                        var feature = dataSource[featureID];
                        var statusEmoji = feature.fail === 0 ? \"\u{2705}\" : \"\u{26A0}\uFE0F\";

                        $(\"#modal-status-emoji\").text(statusEmoji);
                        $(\"#modal-title\").text(feature.name);

                        // Tags
                        var tags = getFeatureTags(feature);
                        $(\"#modal-tags\").empty();
                        tags.forEach(function(t) {
                            $(\"#modal-tags\").append(`<span class=\"test-row-tag\">\u{1F3F7}\uFE0F ${t}</span>`);
                        });

                        // Summary stats
                        var passPct = feature.total > 0 ? Math.round((feature.pass / feature.total) * 100) : 0;
                        $(\"#modal-summary\").html(
                            `<div class=\"modal-stat\"><span class=\"stat-emoji\">\u{1F4CB}</span><span>${feature.total} total</span></div>` +
                            `<div class=\"modal-stat\"><span class=\"stat-emoji\">\u{2705}</span><span>${feature.pass} passed</span></div>` +
                            `<div class=\"modal-stat\"><span class=\"stat-emoji\">\u{274C}</span><span>${feature.fail} failed</span></div>` +
                            `<div class=\"modal-stat\"><span class=\"stat-emoji\">\u{1F4CA}</span><span>${passPct}% pass rate</span></div>`
                        );

                        // Test list
                        $(\"#modal-tests\").empty();
                        feature.tests.forEach(function(test) {
                            $(\"#modal-tests\").append(buildTestRow(test));
                        });

                        openModal();
                    }
                </script>"
    end
end
