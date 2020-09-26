
module NxgJavascript

    def js_detect_system_dark_mode()
        "if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            $(document.documentElement).attr(\"theme\", \"dark\");
            $(\"#theme-icon\").text(\"brightness_2\");
        }"
    end

    def js(data_provider)

        js_array = data_provider[:features].to_s.gsub("=>", ":")

        return "<script>
                    var displayFailuresOnly = false;
                
                    const allFeatures = #{js_array};
                
                    var dataSource = [];
                
                    const STATUS = {
                        pass: \"check_circle\",
                        fail: \"cancel\",
                    };
                
                    function onRefresh() {
                        dataSource = allFeatures;
                        setFilter();
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
                
                        $(\"#sidebar-overlay\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-overlay\").css(\"margin-left\", \"40%\");
                        $(\"#sidebar\").css(\"width\", \"40%\");
                        $(\"#sidebar-title\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-status\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-title\").css(\"opacity\", \"1\");
                        $(\"#sidebar-status\").css(\"opacity\", \"1\");
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
                            }</i>&nbsp;&nbsp;<h4 id=\"test-title\">${test.name}</h4>${
                            test.comments !== \"\"
                                ? `<p id=\"error-message\">${test.comments}</p>`
                                : \"\"
                            }</div>`
                        );
                        });
                    }
                
                    function switchTheme() {
                        currentTheme = $(document.documentElement).attr(\"theme\");
                        $(document.documentElement).attr(\"theme\", currentTheme === \"dark\" ? \"light\" : \"dark\");
                        $(\"#theme-icon\").text(currentTheme === \"dark\" ? \"wb_sunny\" : \"brightness_2\");
                    }
                
                    function closeDetails() {
                        $(\"#sidebar-title\").css(\"visibility\", \"hidden\");
                        $(\"#sidebar-status\").css(\"visibility\", \"hidden\");
                        $(\"#sidebar-title\").css(\"opacity\", \"0\");
                        $(\"#sidebar-status\").css(\"opacity\", \"0\");
                        
                        $(\"#sidebar-overlay\").css(\"margin-left\", \"0\");
                        $(\"#sidebar-overlay\").css(\"visibility\", \"hidden\");
                        $(\"#sidebar\").css(\"width\", \"0\");
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
                
                        $(\"#sidebar-overlay\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-overlay\").css(\"margin-left\", \"40%\");
                        $(\"#sidebar\").css(\"width\", \"40%\");
                        $(\"#sidebar-title\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-status\").css(\"visibility\", \"visible\");
                        $(\"#sidebar-title\").css(\"opacity\", \"1\");
                        $(\"#sidebar-status\").css(\"opacity\", \"1\");
                        /* Update Test Information */
                
                        $(\"#sidebar-title\").text(feature.name);
                        $(\"#sidebar-overlay-grid\").empty();
                        feature.tests.forEach((test) => {
                        $(\"#sidebar-overlay-grid\").append(
                                `<div id=\"sidebar-overlay-test-info\" onclick=\"()=>{}\"><i class=\"${
                                test.testPass ? \"green-font\" : \"red-font\"
                                } material-icons\" style=\"font-size: 1em\">${
                                test.testPass ? STATUS.pass : STATUS.fail
                                }</i>&nbsp;&nbsp;<h4 id=\"test-title\">${test.name}</h4>${
                                test.comments !== \"\"
                                    ? `<p id=\"error-message\">${test.comments}</p>`
                                    : \"\"
                                }</div>`
                            );
                        });
                
                        for (index = 0; index < feature.tests.length; index++) {
                            if (!feature.tests[index].testPass) {
                                $(\"#sidebar-status\").text(STATUS.fail);
                                return;
                            }
                        }
                        $(\"#sidebar-status\").text(STATUS.pass);
                    }
                </script>"
    end
end