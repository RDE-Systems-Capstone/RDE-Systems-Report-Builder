/*
JavaScript/JQuery code to support DOM manipulation of builder page
*/

//Allow drag and drop of filters to filter area
$(document).ready(function() { 	//only run once page is ready
	//Load output section based on report chosen
	$("#report_type").change(function() {
		if ($("#report_type").val() === "trend") {
			$("#output").load("forms/trend.cfm");
		}
		if ($("#report_type").val() === "bar") {
			$("#output").load("forms/bar.cfm");
		}
	});
});

