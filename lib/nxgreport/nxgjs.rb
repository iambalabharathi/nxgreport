
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
                    var catergories = [];
                
                    function onRefresh() {
                        dataSource = allFeatures;
                        setFilter();
                        currentTheme = $(document.documentElement).attr(\"theme\");
                        $(\"#theme-icon\").text(currentTheme === \"dark\" ? \"brightness_2\" : \"wb_sunny\");
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
                        catergories = [];
                
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
                
                        $(\"#body-wrap\").css(\"overflow\", \"hidden\");
                        $(\"#sidebar-overlay\").css(\"overflow\", \"auto\");
                        $(\"#sidebar-overlay\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-overlay\").css(\"margin-left\", \"40%\");
                        $(\"#sidebar\").css(\"width\", \"40%\");
                        $(\"#sidebar-title\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-status\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-title\").css(\"opacity\", \"1\");
                        $(\"#sidebar-status\").css(\"opacity\", \"1\");
                        $(\"#sidebar-catergories\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-catergories\").css(\"opacity\", \"1\");
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
                            }</i>&nbsp;&nbsp;<h4 id=\"test-title\">${test.name}</h4><div><h4 id=\"test-execution-time\">${test.time} secs</h4></div>${
                            test.comments !== \"\"
                                ? `<p id=\"error-message\">${test.comments}</p>`
                                : \"\"
                            }</div>`
                        );
                            categorize(test);
                        });
                        displayCategories();
                    }

                    function displayCategories() {
                        $(\"#sidebar-catergories\").empty();
                        if(catergories.length === 1) { return; }
                        catergories.forEach((cat) => {$(\"#sidebar-catergories\").append(`<div><h6>#${cat.name}</h6></div>`);});
                    }
                
                    function switchTheme() {
                        currentTheme = $(document.documentElement).attr(\"theme\");
                        $(document.documentElement).attr(\"theme\", currentTheme === \"dark\" ? \"light\" : \"dark\");
                        $(\"#theme-icon\").text(currentTheme === \"dark\" ? \"wb_sunny\" : \"brightness_2\");
                    }
                
                    function closeDetails(e) {
                        if (e.target.id === \"sidebar\" || e.target.id === \"sidebar-overlay\") {
                            $(\"#sidebar-catergories\").css(\"visibility\", \"hidden\");
                            $(\"#sidebar-catergories\").css(\"opacity\", \"0\");
                            $(\"#sidebar-title\").css(\"visibility\", \"hidden\");
                            $(\"#sidebar-status\").css(\"visibility\", \"hidden\");
                            $(\"#sidebar-title\").css(\"opacity\", \"0\");
                            $(\"#sidebar-status\").css(\"opacity\", \"0\");
                            $(\"#sidebar-overlay\").css(\"margin-left\", \"0\");
                            $(\"#sidebar-overlay\").css(\"visibility\", \"hidden\");
                            $(\"#sidebar\").css(\"width\", \"0\");
                            $(\"#body-wrap\").css(\"overflow\", \"auto\");
                            $(\"#sidebar-overlay\").css(\"overflow\", \"hidden\");
                        }
                    }
                
                    window
                        .matchMedia(\"(prefers-color-scheme: dark)\")
                        .addEventListener(\"change\", (e) => {
                            darkTheme = e.matches;
                            $(document.documentElement).attr(\"theme\", darkTheme ? \"dark\" : \"light\");
                            $(\"#theme-icon\").text(darkTheme ? \"brightness_2\" : \"wb_sunny\");
                        });
                
                    function showDetails(featureID) {
                        feature = dataSource[featureID];
                        catergories = [];
                
                        $(\"#body-wrap\").css(\"overflow\", \"hidden\");
                        $(\"#sidebar-overlay\").css(\"overflow\", \"auto\");
                        $(\"#sidebar-overlay\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-overlay\").css(\"margin-left\", \"40%\");
                        $(\"#sidebar\").css(\"width\", \"40%\");
                        $(\"#sidebar-title\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-status\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-title\").css(\"opacity\", \"1\");
                        $(\"#sidebar-status\").css(\"opacity\", \"1\");
                        $(\"#sidebar-catergories\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-catergories\").css(\"opacity\", \"1\");
                        /* Update Test Information */
                
                        $(\"#sidebar-title\").text(feature.name);
                        $(\"#sidebar-overlay-grid\").empty();
                        feature.tests.forEach((test) => {
                        $(\"#sidebar-overlay-grid\").append(
                                `<div id=\"sidebar-overlay-test-info\" onclick=\"()=>{}\"><i class=\"${
                                test.testPass ? \"green-font\" : \"red-font\"
                                } material-icons\" style=\"font-size: 1em\">${
                                test.testPass ? STATUS.pass : STATUS.fail
                                }</i>&nbsp;&nbsp;<h4 id=\"test-title\">${test.name}</h4><div><h4 id=\"test-execution-time\">${test.time} secs</h4></div>${
                                test.comments !== \"\"
                                    ? `<p id=\"error-message\">${test.comments}</p>`
                                    : \"\"
                                }</div>`
                            );
                            categorize(test);
                        });
                        displayCategories();

                        for (index = 0; index < feature.tests.length; index++) {
                            if (!feature.tests[index].testPass) {
                                $(\"#sidebar-status\").text(STATUS.fail);
                                return;
                            }
                        }
                        $(\"#sidebar-status\").text(STATUS.pass);
                    }

                    function categorize(test) {
                        if (test.tag === \"\") {
                            return;
                        }
                        if (!catergoryAdded(test.tag)) {
                            catergories.push({ name: test.tag.toLowerCase(), tests: [test] });
                        } else {
                            catergories[catergoryIndex(test.tag)].tests.push(test);
                        }
                    }

                    function catergoryAdded(category) {
                        for (var i = 0; i < catergories.length; i++) {
                            if (catergories[i].name === category.toLowerCase()) {
                            return true;
                            }
                        }
                        return false;
                    }

                    function catergoryIndex(category) {
                        for (var i = 0; i < catergories.length; i++) {
                            if (catergories[i].name === category.toLowerCase()) {
                            return i;
                            }
                        }
                        return 0;
                    }
                </script>"
    end
end